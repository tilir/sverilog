ADD_SV_TEST(latches
  TOP latches_testbench
  SOURCES
    ${CMAKE_SOURCE_DIR}/util/tb_util.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/latches.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/latches_testbench.sv)
