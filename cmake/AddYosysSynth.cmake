# Synthesize one SystemVerilog top and keep inspectable output artifacts.
function(ADD_YOSYS_SYNTH NAME)
  cmake_parse_arguments(YS "" "TOP" "SOURCES" ${ARGN})
  if(NOT YS_TOP OR NOT YS_SOURCES)
    message(FATAL_ERROR "ADD_YOSYS_SYNTH(${NAME}) requires TOP and SOURCES")
  endif()

  set(OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/${NAME})
  set(JSON_NETLIST ${OUTPUT_DIR}/${NAME}.json)
  set(VERILOG_NETLIST ${OUTPUT_DIR}/${NAME}.v)
  set(SYNTH_LOG ${OUTPUT_DIR}/${NAME}.log)
  string(REPLACE ";" " " SOURCE_TEXT "${YS_SOURCES}")

  add_custom_command(
    OUTPUT ${JSON_NETLIST} ${VERILOG_NETLIST} ${SYNTH_LOG}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${OUTPUT_DIR}
    COMMAND ${YOSYS_EXECUTABLE} -q -l ${SYNTH_LOG} -p
            "read_verilog -sv -DSYNTHESIS ${SOURCE_TEXT}; synth -top ${YS_TOP}; stat; write_json ${JSON_NETLIST}; write_verilog -noattr ${VERILOG_NETLIST}"
    COMMENT "Synthesize ${YS_TOP} with Yosys"
    DEPENDS ${YS_SOURCES}
    VERBATIM)

  add_custom_target(synth_${NAME}
    DEPENDS ${JSON_NETLIST} ${VERILOG_NETLIST} ${SYNTH_LOG})
endfunction()
