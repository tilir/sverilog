# System Verilog samples

[![CI](https://github.com/tilir/sverilog/actions/workflows/ci.yml/badge.svg)](https://github.com/tilir/sverilog/actions/workflows/ci.yml)

Personal SystemVerilog examples and small projects. The test suites use
Verilator by default; Icarus Verilog is supported where its SystemVerilog
frontend can compile the example.

Build line:

    cmake -DCMAKE_BUILD_TYPE=Release -S . -B build && cmake --build ./build

Verilator is used by default. Select Icarus Verilog when configuring a
separate build directory:

    cmake -S . -B build-iverilog -DSIMULATOR=iverilog
    cmake --build build-iverilog

The Icarus configuration builds the `combinational`, `muxes`, `latches`, and
`counter` test suites. RMC experiments and the interface-based RAM remain in
the Verilator configuration because they use unsupported SystemVerilog
constructs.

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

RMC is enabled for local builds by default but excluded from CI. It can be
disabled explicitly with `-DENABLE_RMC=OFF`.

To add an experiment, create `rmc/<name>.sv` containing `module <name>`.
CMake discovers it automatically and creates `rmc_<name>` (compile) and
`run_rmc_<name>` (compile and run) targets. Supporting `.txt`, `.mem`, and
`.hex` files are copied to the experiment working directory automatically.

Synthesize a few example designs when Yosys is installed:

    cmake --build build --target synth

Individual targets include `synth_counter`, `synth_gates`,
`synth_mux4_behavioral`, and `synth_mux4_structural`. Generated JSON,
structural Verilog, and synthesis logs are placed under `build/synth/`.

Contents (in order of teaching):

* rmc -- simple tests with system verilog, like readmemb
* util -- shared self-checking testbench scoreboard
* combinational -- combinational logic examples and exhaustive tests
* muxes -- behavioral, structural, and tristate multiplexors
* latches -- gate-level and behavioral SR latches
* counter -- loadable up/down counter
* ram -- synchronous RAM using interfaces and modports
* synth -- selected Yosys synthesis experiments
