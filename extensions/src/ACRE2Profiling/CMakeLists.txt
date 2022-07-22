cmake_minimum_required (VERSION 3.0)

option(USE_TRACY "USE_TRACY" OFF)

set(ACRE_NAME "ACRE2Profiling")

acre_set_linker_options()

file(GLOB SOURCES *.h *.hpp *.c *.cpp)

add_library( ${ACRE_NAME} STATIC ${SOURCES} ${GLOBAL_SOURCES} ${DSP_SOURCES})
target_link_libraries( ${ACRE_NAME} )
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2)

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tracy/CMakeLists.txt")
	message(FATAL_ERROR "Unable to locate tracy submodule - did you forget to run git submodule update --init?")
endif()

set(TRACY_ENABLE ${USE_TRACY} CACHE BOOL "" FORCE)
set(TRACY_ON_DEMAND ON CACHE BOOL "" FORCE)
add_subdirectory("tracy")

target_link_libraries( ${ACRE_NAME} Tracy::TracyClient)