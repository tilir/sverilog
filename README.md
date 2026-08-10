# System Verilog samples

[![CI](https://github.com/tilir/sverilog/actions/workflows/ci.yml/badge.svg)](https://github.com/tilir/sverilog/actions/workflows/ci.yml)

Personal system verilog examples and small projects

Using verilator 5.020

Build line:

    cmake -DCMAKE_BUILD_TYPE=Release -S . -B build && cmake --build ./build

Verilator is used by default. Select Icarus Verilog when configuring a
separate build directory:

    cmake -S . -B build-iverilog -DSIMULATOR=iverilog
    cmake --build build-iverilog

The Icarus configuration currently builds the `combinational`, `muxes`, and
`latches` test suites. The remaining older testbenches use SystemVerilog
constructs unsupported by Icarus 12 and remain available in the default
Verilator configuration.

Build and run only the combinational examples:

    cmake -S . -B build && cmake --build build --target combinational

Build and run only the multiplexor examples:

    cmake -S . -B build && cmake --build build --target muxes

Build and run only the latch examples:

    cmake -S . -B build && cmake --build build --target latches

Build and run the interface-based RAM example (Verilator):

    cmake -S . -B build && cmake --build build --target ram

Build all single-file experiments, or one experiment by name (Verilator):

    cmake --build build --target rmc
    cmake --build build --target run_rmc_readmem_check

To add an experiment, create `rmc/<name>.sv` containing `module <name>`.
CMake discovers it automatically and creates `rmc_<name>` (compile) and
`run_rmc_<name>` (compile and run) targets. Supporting `.txt`, `.mem`, and
`.hex` files are copied to the experiment working directory automatically.

Contents (in order of teaching):

* rmc -- simple tests with system verilog, like readmemb
* util -- some handy utils, like result checker
* combinational -- different comb logic examples and testbench
* muxes -- experiments with multiplexors
* latches -- experiments with latches
