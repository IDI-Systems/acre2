cmake_minimum_required (VERSION 3.0)

project(Wav2B64)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Extras/")

file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp)

add_executable(Wav2B64 ${SOURCES})
set_target_properties(Wav2B64 PROPERTIES FOLDER Extras)

