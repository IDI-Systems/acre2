cmake_minimum_required (VERSION 3.10)

project(Wav2B64)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Extras/")

file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp)

add_executable(Wav2B64 ${SOURCES} ${GLOBAL_SOURCES})
set_target_properties(Wav2B64 PROPERTIES FOLDER Extras)


# Copy to extras folder and symbols
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    # Copy DLL to extras
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_SOURCE_DIR}/../../../extras/$<TARGET_FILE_NAME:${PROJECT_NAME}>
    # Copy PDB to symbols
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${PROJECT_NAME}>/${PROJECT_NAME}.pdb ${PROJECT_SOURCE_DIR}/../../../symbols/${ACRE_ARCH}/${PROJECT_NAME}.pdb
)
