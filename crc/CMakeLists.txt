ADD_SV_TEST(crc
  TOP crc_testbench
  IGNORE_TIMESCALE
  SOURCES
    ${CMAKE_SOURCE_DIR}/util/tb_util.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/crc.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/crc_testbench.sv)
