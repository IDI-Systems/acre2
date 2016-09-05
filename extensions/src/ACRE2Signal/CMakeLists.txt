cmake_minimum_required (VERSION 3.0)

set(ACRE_NAME "ACRE2Signal")

acre_set_build_output()
acre_set_linker_options()

file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp)

add_library( ${ACRE_NAME} MODULE ${SOURCES})
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2)

