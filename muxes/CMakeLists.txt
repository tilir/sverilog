ADD_SV_TEST(muxes
  TOP muxes_testbench
  SOURCES
    ${CMAKE_SOURCE_DIR}/util/tb_util.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/muxes.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/muxes_testbench.sv)
