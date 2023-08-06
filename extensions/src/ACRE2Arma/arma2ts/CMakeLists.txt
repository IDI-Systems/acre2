cmake_minimum_required (VERSION 3.10)

set(ACRE_NAME "Arma2TS")

acre_set_build_output()
acre_set_linker_options()

file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp)

add_library( ${ACRE_NAME} MODULE ${SOURCES} ${GLOBAL_SOURCES})
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2Arma)


# Copy and rename
if(USE_64BIT_BUILD)
    set(FINAL_DLL_NAME ACRE2Arma_x64.dll)
else()
    set(FINAL_DLL_NAME ACRE2Arma.dll)
endif()

add_custom_command(TARGET ${ACRE_NAME} POST_BUILD
    # Copy DLL to root
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${ACRE_NAME}> ${PROJECT_SOURCE_DIR}/../${FINAL_DLL_NAME}
    # Copy PDB to symbols
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${ACRE_NAME}>/${ACRE_NAME}.pdb ${PROJECT_SOURCE_DIR}/../symbols/${ACRE_ARCH}/${ACRE_NAME}.pdb
)
