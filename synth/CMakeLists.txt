ADD_YOSYS_SYNTH(counter
  TOP counter
  SOURCES ${CMAKE_SOURCE_DIR}/counter/counter.sv)

ADD_YOSYS_SYNTH(crc_equations
  TOP crc16_8bit_equations
  SOURCES ${CMAKE_SOURCE_DIR}/crc/crc.sv)

ADD_YOSYS_SYNTH(crc_loop
  TOP crc16_8bit_loop
  SOURCES ${CMAKE_SOURCE_DIR}/crc/crc.sv)

ADD_YOSYS_SYNTH(crc_table
  TOP crc16_8bit_table
  SOURCES ${CMAKE_SOURCE_DIR}/crc/crc.sv)

add_custom_target(synth_crc
  DEPENDS
    synth_crc_equations
    synth_crc_loop
    synth_crc_table)

ADD_YOSYS_SYNTH(gates
  TOP gates
  SOURCES ${CMAKE_SOURCE_DIR}/combinational/gates.sv)

ADD_YOSYS_SYNTH(mux4_behavioral
  TOP mux4
  SOURCES ${CMAKE_SOURCE_DIR}/muxes/muxes.sv)

ADD_YOSYS_SYNTH(mux4_structural
  TOP mux4structural
  SOURCES ${CMAKE_SOURCE_DIR}/muxes/muxes.sv)

add_custom_target(synth
  DEPENDS
    synth_counter
    synth_crc
    synth_gates
    synth_mux4_behavioral
    synth_mux4_structural)
