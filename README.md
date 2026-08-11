# SystemVerilog samples

[![CI](https://github.com/tilir/sverilog/actions/workflows/ci.yml/badge.svg)](https://github.com/tilir/sverilog/actions/workflows/ci.yml)

Small SystemVerilog designs and experiments collected while learning the
language. Most examples have self-checking testbenches shared between
Verilator and Icarus Verilog. CMake is the primary build system; Bazel is a
small alternative implementation kept for comparison and experimentation.

## Quick start

Run the regular test suites with Verilator:

```sh
cmake -S . -B build -DENABLE_RMC=OFF
cmake --build build
```

Or run the same supported suites with Bazel:

```sh
bazel test //:all_tests
```

See [Building and testing](docs/building-and-testing.md) for simulator
selection, individual targets, CI behavior, and the differences between the
two build systems.

## Repository map

| Directory | Contents |
| --- | --- |
| `combinational` | Basic gates, Boolean functions, XOR, minority logic, and a seven-segment decoder |
| `muxes` | Behavioral, structural, and tristate multiplexors |
| `latches` | Gate-level and behavioral SR latches |
| `counter` | A synchronous loadable up/down counter |
| `crc` | Equation, unrolled-loop, and lookup-table CRC-16/XMODEM implementations |
| `ram` | Synchronous RAM using interfaces and modports |
| `util` | Shared self-checking testbench scoreboard |
| `rmc` | Independent one-file language experiments |
| `synth` | Designs selected for Yosys synthesis |
| `cmake`, `bazel` | Reusable build helpers |

The directories roughly progress from combinational logic to stateful
designs. `rmc` is intentionally less structured: it is a scratchpad rather
than part of the regular regression suite.

## More documentation

- [Building and testing](docs/building-and-testing.md)
- [Adding examples and RMC experiments](docs/adding-examples.md)
- [Synthesis with Yosys](docs/synthesis.md)

This is a learning repository, so examples favor readability and visible
behavior over reusable IP or production-grade verification infrastructure.
