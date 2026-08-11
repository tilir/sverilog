# Synthesis with Yosys

When `yosys` is available during CMake configuration, the repository enables
a small set of synthesis experiments:

```sh
cmake -S . -B build
cmake --build build --target synth
```

Individual targets are useful when comparing one implementation at a time:

```sh
cmake --build build --target synth_counter
cmake --build build --target synth_crc_equations
cmake --build build --target synth_crc_loop
cmake --build build --target synth_crc_table
cmake --build build --target synth_gates
cmake --build build --target synth_mux4_behavioral
cmake --build build --target synth_mux4_structural
```

The convenience target `synth_crc` builds all three CRC implementations for
side-by-side comparison:

```sh
cmake --build build --target synth_crc
```

Each target asks Yosys to read the selected SystemVerilog sources, elaborate
the chosen top module, run the standard `synth` flow, and write three files
under `build/synth/<name>/`:

- `<name>.json`, a machine-readable synthesized design;
- `<name>.v`, structural Verilog suitable for inspection;
- `<name>.log`, the Yosys command log and statistics.

The behavioral and structural mux4 targets are intentionally separate. Their
outputs make it easy to see whether two differently written descriptions
reduce to equivalent logic.

The CRC targets offer a similar comparison: manually expanded equations, an
eight-iteration algorithmic loop, and a 256-entry lookup table. The generic
Yosys `synth` pass is free to recognize their common Boolean function, so the
table need not survive as a memory in the resulting netlist. Mapping to a
specific FPGA or cell library may produce different tradeoffs.

These are synthesis demonstrations rather than sign-off flows. Testbenches,
delays, assertions, and the RMC experiments are simulation material and are
not synthesis inputs. Yosys targets currently remain CMake-only.
