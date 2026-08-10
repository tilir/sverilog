cmake_minimum_required(VERSION 3.11)
project(SVerilog LANGUAGES NONE)

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

ADD_CUSTOM_TARGET(build-all ALL)
include(cmake/AddSvTest.cmake)

add_subdirectory(combinational)
add_subdirectory(muxes)
add_subdirectory(latches)
add_subdirectory(counter)

IF(SIMULATOR STREQUAL "verilator")
  add_subdirectory(rmc)
  add_subdirectory(ram)
ELSE()
  MESSAGE(STATUS
    "Icarus build: skipping rmc and interface-based ram experiments")
ENDIF()
