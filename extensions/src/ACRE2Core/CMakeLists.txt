cmake_minimum_required (VERSION 3.0)

set(ACRE_NAME "ACRE2Core")

acre_set_linker_options()

file(GLOB SOURCES *.h *.hpp *.c *.cpp)
file(GLOB DSP_SOURCES DspFilters/*.h DspFilters/*.hpp DspFilters/*.c DspFilters/*.cpp)

add_library( ${ACRE_NAME} STATIC ${SOURCES} ${GLOBAL_SOURCES} ${DSP_SOURCES})
target_link_libraries( ${ACRE_NAME} ACRE2Shared)
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2)
