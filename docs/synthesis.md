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
cmake --build build --target synth_crc
cmake --build build --target synth_gates
cmake --build build --target synth_mux4_behavioral
cmake --build build --target synth_mux4_structural
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

These are synthesis demonstrations rather than sign-off flows. Testbenches,
delays, assertions, and the RMC experiments are simulation material and are
not synthesis inputs. Yosys targets currently remain CMake-only.
