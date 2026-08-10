# Building and testing

## Requirements

The primary CMake build requires CMake and one of these simulators:

- Verilator, used by default;
- Icarus Verilog (`iverilog` and `vvp`).

Bazelisk is convenient for the alternative build because the repository pins
its Bazel version in `.bazelversion`. Yosys is optional and only enables the
synthesis targets described in [Synthesis with Yosys](synthesis.md).

## CMake

Configure and run the regular suites with Verilator:

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DENABLE_RMC=OFF
cmake --build build
```

RMC is enabled by default for local experimentation. Passing
`-DENABLE_RMC=OFF` keeps a normal regression run focused on the self-checking
suites.

Use a separate build directory for Icarus Verilog:

```sh
cmake -S . -B build-iverilog -DSIMULATOR=iverilog
cmake --build build-iverilog
```

Icarus builds `combinational`, `muxes`, `latches`, and `counter`. The RAM
example uses interfaces and modports that this build does not support. RMC is
also Verilator-only.

Each suite has a public target that compiles and runs it:

```sh
cmake --build build --target combinational
cmake --build build --target muxes
cmake --build build --target latches
cmake --build build --target counter
cmake --build build --target ram
```

Internally, `ADD_SV_TEST` also creates `<name>_sim` and `run_<name>` targets.
The public `<name>` target is normally the useful one.

## Bazel

The root package provides simulator-specific test suites:

```sh
bazel test //:verilator_tests
bazel test //:iverilog_tests
bazel test //:all_tests
```

An individual test can be selected with its package label:

```sh
bazel test //combinational:test_verilator
bazel test //muxes:test_iverilog
```

To compile every Bazel target without running simulations:

```sh
bazel build //...
```

The implementation in `bazel/systemverilog.bzl` intentionally uses
`verilator`, `iverilog`, and `vvp` from `PATH`. This makes the rule short and
useful for studying Starlark, but it is not a hermetic Bazel toolchain and is
not intended for remote execution.

## Testbench structure

The regular testbenches import `tb_util_pkg` from `util/tb_util.sv`. Its
scoreboard counts checks, groups them into named sections, prints useful
expected/actual diagnostics, and exits with a failure when any check fails.
This keeps the individual benches focused on stimulus and reference results.

Combinational designs are tested exhaustively where the input space is small.
Stateful designs use directed sequences that cover reset, normal operation,
boundary conditions, and invalid or special states.

## Continuous integration

GitHub Actions contains two CMake simulation jobs, one for each simulator.
They compile and run the supported tests with RMC disabled. A separate Bazel
job executes `bazel build //...`: it verifies the duplicate build description
without running a second copy of the simulations.
