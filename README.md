# System Verilog samples

Personal system verilog examples and small projects

Using verilator 5.020

Build line:

    cmake -DCMAKE_BUILD_TYPE=Release -S . -B build && cmake --build ./build

Verilator is used by default. Select Icarus Verilog when configuring a
separate build directory:

    cmake -S . -B build-iverilog -DSIMULATOR=iverilog
    cmake --build build-iverilog

The Icarus configuration currently builds the `combinational` and `muxes`
test suites. The older testbenches use SystemVerilog constructs unsupported by
Icarus 12 and remain available in the default Verilator configuration.

Build and run only the combinational examples:

    cmake -S . -B build && cmake --build build --target combinational

Build and run only the multiplexor examples:

    cmake -S . -B build && cmake --build build --target muxes

Contents (in order of teaching):

* rmc -- simple tests with system verilog, like readmemb
* util -- some handy utils, like result checker
* combinational -- different comb logic examples and testbench
* muxes -- experiments with multiplexors
* latches -- experiments with latches
