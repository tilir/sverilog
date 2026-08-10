CMAKE_MINIMUM_REQUIRED(VERSION 3.11)
PROJECT(SVerilog)

SET(SIMULATOR "verilator" CACHE STRING "SystemVerilog simulator (verilator or iverilog)")
SET_PROPERTY(CACHE SIMULATOR PROPERTY STRINGS verilator iverilog)

IF(SIMULATOR STREQUAL "verilator")
  FIND_PROGRAM(COMPILER verilator REQUIRED)
ELSEIF(SIMULATOR STREQUAL "iverilog")
  FIND_PROGRAM(COMPILER iverilog REQUIRED)
  FIND_PROGRAM(SIMULATOR_RUNNER vvp REQUIRED)
ELSE()
  MESSAGE(FATAL_ERROR "Unknown SIMULATOR='${SIMULATOR}'; use verilator or iverilog")
ENDIF()

MESSAGE(STATUS "SystemVerilog simulator: ${SIMULATOR} (${COMPILER})")

SET(OPTS
  -cc
  --timing
  --build
  --main
  --exe)

ADD_CUSTOM_TARGET(build-all ALL)

add_subdirectory(combinational)
add_subdirectory(muxes)

IF(SIMULATOR STREQUAL "verilator")
  add_subdirectory(latches)
  add_subdirectory(rmc)
  add_subdirectory(counter)
  add_subdirectory(ram)
ELSE()
  MESSAGE(STATUS
    "Icarus build: skipping legacy latches, rmc, counter, and ram testbenches")
ENDIF()

# Public entry point for building and running only the combinational examples.
ADD_CUSTOM_TARGET(combinational
  DEPENDS runsim_combinatorial)

# Public entry point for building and running only the mux examples.
ADD_CUSTOM_TARGET(muxes
  DEPENDS runsim_muxes)
