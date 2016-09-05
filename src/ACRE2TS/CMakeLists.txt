cmake_minimum_required (VERSION 3.0)

set(ACRE_NAME "ACRE2TS")

acre_set_build_output()
acre_set_linker_options()

file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp inc/*)

include_directories(inc)

set(ACRE2UI "")
if(USE_ACRE2UI) 
	set(ACRE2UI "ACRE2UI")
	add_definitions( -DUSE_ACRE2UI )
endif()

add_library( ${ACRE_NAME} MODULE ${SOURCES})
target_link_libraries(${ACRE_NAME} ACRE2Core ACRE2Shared x3daudio ${ACRE2UI})
target_include_directories(${ACRE_NAME} PUBLIC ../ACRE2UI)
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2)

