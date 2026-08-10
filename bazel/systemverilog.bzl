"""Small, deliberately local SystemVerilog simulation rules.

The rules use Verilator, Icarus Verilog, and vvp from PATH.  This keeps the
teaching repository dependency-free, but is intentionally not a hermetic
compiler toolchain.
"""

def _quote(value):
    return "'" + value.replace("'", "'\"'\"'") + "'"

def _sv_test_impl(ctx):
    image_suffix = ".vvp" if ctx.attr.simulator == "iverilog" else ".bin"
    image = ctx.actions.declare_file(ctx.label.name + image_suffix)
    runner = ctx.actions.declare_file(ctx.label.name + "_runner.sh")
    sources = " ".join([_quote(src.path) for src in ctx.files.srcs])

    if ctx.attr.simulator == "verilator":
        warning_flags = [
            "-Wall",
            "-Wno-fatal",
            "-Wno-DECLFILENAME",
            "-Wno-WIDTHEXPAND",
        ]
        if ctx.attr.ignore_timescale:
            warning_flags.append("-Wno-TIMESCALEMOD")

        command = """
set -eu
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT
verilator --binary --trace-fst {warnings} \
  --top-module {top} {sources} --Mdir "$work_dir" -o simulation
cp "$work_dir/simulation" {image}
""".format(
            warnings = " ".join(warning_flags),
            top = _quote(ctx.attr.top),
            sources = sources,
            image = _quote(image.path),
        )
        runner_command = "exec \"$(dirname \"$0\")/{image}\" \"$@\"".format(
            image = image.basename,
        )
    else:
        command = "iverilog -g2012 -s {top} -o {image} {sources}".format(
            top = _quote(ctx.attr.top),
            image = _quote(image.path),
            sources = sources,
        )
        runner_command = "exec vvp \"$(dirname \"$0\")/{image}\" \"$@\"".format(
            image = image.basename,
        )

    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = [image],
        command = command,
        mnemonic = "SystemVerilogCompile",
        progress_message = "Compiling %{label} with " + ctx.attr.simulator,
        use_default_shell_env = True,
    )
    ctx.actions.write(
        output = runner,
        content = "#!/usr/bin/env bash\nset -euo pipefail\n" + runner_command + "\n",
        is_executable = True,
    )

    return [DefaultInfo(
        executable = runner,
        files = depset([image, runner]),
        runfiles = ctx.runfiles(files = [image] + ctx.files.data),
    )]

sv_test = rule(
    implementation = _sv_test_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".sv"], mandatory = True),
        "top": attr.string(mandatory = True),
        "simulator": attr.string(
            default = "verilator",
            values = ["verilator", "iverilog"],
        ),
        "ignore_timescale": attr.bool(default = False),
        "data": attr.label_list(allow_files = True),
    },
    test = True,
)

def sv_test_pair(name, srcs, top, iverilog = True, ignore_timescale = False):
    """Defines equivalent Verilator and, when supported, Icarus tests."""
    sv_test(
        name = name + "_verilator",
        srcs = srcs,
        top = top,
        simulator = "verilator",
        ignore_timescale = ignore_timescale,
        size = "small",
        tags = ["verilator"],
        visibility = ["//visibility:public"],
    )
    if iverilog:
        sv_test(
            name = name + "_iverilog",
            srcs = srcs,
            top = top,
            simulator = "iverilog",
            size = "small",
            tags = ["iverilog"],
            visibility = ["//visibility:public"],
        )
