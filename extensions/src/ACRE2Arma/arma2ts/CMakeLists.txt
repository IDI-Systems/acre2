cmake_minimum_required (VERSION 3.0)

set(ACRE_NAME "Arma2TS")

acre_set_build_output()
acre_set_linker_options()

file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp)

add_library( ${ACRE_NAME} MODULE ${SOURCES})
set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2Arma)

# Copy to root and rename
if(USE_64BIT_BUILD)
    add_custom_command(TARGET ${ACRE_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${ACRE_NAME}> ${PROJECT_SOURCE_DIR}/../ACRE2Arma_64.dll
    )
else()
    add_custom_command(TARGET ${ACRE_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${ACRE_NAME}> ${PROJECT_SOURCE_DIR}/../ACRE2Arma.dll
    )
endif()
