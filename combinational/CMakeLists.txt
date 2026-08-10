ADD_SV_TEST(combinational
  TOP comb_testbench
  SOURCES
    ${CMAKE_SOURCE_DIR}/util/tb_util.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/sillyfunction.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/gates.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/xorfour.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/minmaj.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/sevensegment.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/comb_testbench.sv)
