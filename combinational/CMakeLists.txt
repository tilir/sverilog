SET(SIMV combinatorial)
SET(SRC
  ${CMAKE_CURRENT_SOURCE_DIR}/sillyfunction.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/gates.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/xorfour.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/minmaj.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/muxes.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/sevensegment.sv
  ${CMAKE_CURRENT_SOURCE_DIR}/comb_testbench.sv
)

# Build a self-contained SystemVerilog testbench.  Tracing is compiled in but
# only enabled at runtime with +trace.
ADD_CUSTOM_TARGET(${SIMV}
  COMMAND ${COMPILER} --binary --trace-fst -Wall -Wno-fatal
          -Wno-DECLFILENAME -Wno-WIDTHEXPAND
          --top-module comb_testbench
          ${SRC} --Mdir ${CMAKE_CURRENT_BINARY_DIR} -o ${SIMV}
  COMMENT "Compile combinational self-checking testbench"
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS ${SRC})

ADD_CUSTOM_TARGET(runsim_${SIMV}
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${SIMV}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS ${SIMV})

ADD_DEPENDENCIES(build-all runsim_${SIMV})
