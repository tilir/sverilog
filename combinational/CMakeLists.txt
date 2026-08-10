SET(SIMV combinatorial)
SET(SRC
  ${CMAKE_SOURCE_DIR}/util/tb_util.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/sillyfunction.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/gates.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/xorfour.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/minmaj.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/sevensegment.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/comb_testbench.sv
)

# Build a self-contained SystemVerilog testbench.  Tracing is compiled in but
# only enabled at runtime with +trace.
IF(SIMULATOR STREQUAL "verilator")
  ADD_CUSTOM_TARGET(${SIMV}
    COMMAND ${COMPILER} --binary --trace-fst -Wall -Wno-fatal
            -Wno-DECLFILENAME -Wno-WIDTHEXPAND
            --top-module comb_testbench
            ${SRC} --Mdir ${CMAKE_CURRENT_BINARY_DIR} -o ${SIMV}
    COMMENT "Compile combinational testbench with Verilator"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${SRC})
  SET(SIM_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${SIMV})
ELSE()
  SET(SIM_IMAGE ${CMAKE_CURRENT_BINARY_DIR}/${SIMV}.vvp)
  ADD_CUSTOM_TARGET(${SIMV}
    COMMAND ${COMPILER} -g2012 -s comb_testbench -o ${SIM_IMAGE} ${SRC}
    COMMENT "Compile combinational testbench with Icarus Verilog"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${SRC})
  SET(SIM_COMMAND ${SIMULATOR_RUNNER} ${SIM_IMAGE})
ENDIF()

ADD_CUSTOM_TARGET(runsim_${SIMV}
  COMMAND ${SIM_COMMAND}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS ${SIMV})

ADD_DEPENDENCIES(build-all runsim_${SIMV})
