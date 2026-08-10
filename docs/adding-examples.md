# Adding examples and experiments

## Add a regular tested design

A regular example normally consists of a design file and a self-checking
testbench in the same directory. Import the shared scoreboard in the bench:

```systemverilog
module example_testbench;
  import tb_util_pkg::*;

  logic actual;
  logic expected;

  initial begin
    init_tests();
    begin_test("basic behavior");

    // Drive the DUT, wait for it to settle, then check the result.
    check("example.y", actual, expected, 1, "input description");

    end_test("basic behavior");
    finish_tests("example");
  end
endmodule
```

The existing benches are the authoritative examples for the precise helper
methods and timing style.

Register the suite with CMake in the directory's `CMakeLists.txt`:

```cmake
ADD_SV_TEST(example
  TOP example_testbench
  SOURCES
    ${CMAKE_SOURCE_DIR}/util/tb_util.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/example.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/example_testbench.sv)
```

Then add the corresponding Bazel declaration to `BUILD.bazel`:

```starlark
load("//bazel:systemverilog.bzl", "sv_test_pair")

sv_test_pair(
    name = "test",
    top = "example_testbench",
    srcs = [
        "//util:tb_util.sv",
        "example.sv",
        "example_testbench.sv",
    ],
)
```

`sv_test_pair` creates both `test_verilator` and `test_iverilog`. Pass
`iverilog = False` when the example deliberately uses unsupported Icarus
features. If the package is new, also list its targets in the root test
suites in `BUILD.bazel` and add its directory from the root `CMakeLists.txt`.

The source list appears once per build system, but testbench behavior remains
shared: there is no simulator-specific copy of the SystemVerilog bench.

## Add a one-file RMC experiment

`rmc` is for small questions such as how a language construct behaves or how
a simulator reads a data file. Create `rmc/<name>.sv` with a top-level module
whose name matches the file:

```systemverilog
module short_experiment;
  initial begin
    // Experiment here.
    $finish;
  end
endmodule
```

Configure a Verilator build with RMC enabled (the default), then run either
all experiments or just the new one:

```sh
cmake -S . -B build
cmake --build build --target rmc
cmake --build build --target run_rmc_short_experiment
```

CMake discovers `.sv` files automatically. Files ending in `.txt`, `.mem`,
or `.hex` are copied into the RMC working directory, so file-reading examples
can keep their input beside their source.

RMC experiments are deliberately excluded from Bazel and CI. They do not
need to become stable regression tests unless an experiment grows into a
regular example.
