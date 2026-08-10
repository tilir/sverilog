ADD_SV_TEST(ram
  TOP ram_testbench
  IGNORE_TIMESCALE
  SOURCES
    ${CMAKE_SOURCE_DIR}/util/tb_util.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/ram.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/ram_testbench.sv)
