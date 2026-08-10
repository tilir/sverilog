ADD_SV_TEST(counter
  TOP counter_testbench
  SOURCES
    ${CMAKE_SOURCE_DIR}/util/tb_util.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/counter.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/counter_bench.sv)
