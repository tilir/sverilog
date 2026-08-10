# Add a self-checking SystemVerilog suite with build, run, and public targets.
function(ADD_SV_TEST NAME)
  cmake_parse_arguments(SV "IGNORE_TIMESCALE" "TOP" "SOURCES" ${ARGN})
  if(NOT SV_TOP OR NOT SV_SOURCES)
    message(FATAL_ERROR "ADD_SV_TEST(${NAME}) requires TOP and SOURCES")
  endif()

  set(BUILD_TARGET ${NAME}_sim)
  set(RUN_TARGET run_${NAME})
  if(SIMULATOR STREQUAL "verilator")
    set(WARNINGS -Wall -Wno-fatal -Wno-DECLFILENAME -Wno-WIDTHEXPAND)
    if(SV_IGNORE_TIMESCALE)
      list(APPEND WARNINGS -Wno-TIMESCALEMOD)
    endif()
    add_custom_target(${BUILD_TARGET}
      COMMAND ${COMPILER} --binary --trace-fst ${WARNINGS}
              --top-module ${SV_TOP} ${SV_SOURCES}
              --Mdir ${CMAKE_CURRENT_BINARY_DIR} -o ${NAME}
      COMMENT "Compile ${NAME} testbench with Verilator"
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      DEPENDS ${SV_SOURCES})
    set(RUN_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${NAME})
  else()
    set(SIM_IMAGE ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.vvp)
    add_custom_target(${BUILD_TARGET}
      COMMAND ${COMPILER} -g2012 -s ${SV_TOP} -o ${SIM_IMAGE} ${SV_SOURCES}
      COMMENT "Compile ${NAME} testbench with Icarus Verilog"
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      DEPENDS ${SV_SOURCES})
    set(RUN_COMMAND ${SIMULATOR_RUNNER} ${SIM_IMAGE})
  endif()

  add_custom_target(${RUN_TARGET}
    COMMAND ${RUN_COMMAND}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${BUILD_TARGET})
  add_custom_target(${NAME} DEPENDS ${RUN_TARGET})
  add_dependencies(build-all ${NAME})
endfunction()
