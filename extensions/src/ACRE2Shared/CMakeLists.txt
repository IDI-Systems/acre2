cmake_minimum_required (VERSION 3.0)

set(ACRE_NAME "ACRE2Shared")

acre_set_linker_options()

file(GLOB SOURCES *.h *.hpp *.c *.cpp)

add_library( ${ACRE_NAME} STATIC ${SOURCES} ${GLOBAL_SOURCES})
target_link_libraries( ${ACRE_NAME})
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2)
