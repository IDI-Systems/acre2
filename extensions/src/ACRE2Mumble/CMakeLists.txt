cmake_minimum_required (VERSION 3.10)

set(ACRE_NAME "ACRE2Mumble")

acre_set_build_output()
acre_set_linker_options()

enable_language(ASM_MASM)
file(GLOB_RECURSE SOURCES *.h *.hpp *.c *.cpp *.asm mumble_includes/*)

include_directories(mumble_includes)

add_library( ${ACRE_NAME} MODULE ${SOURCES} ${GLOBAL_SOURCES})
if(WIN32)
    target_link_libraries(${ACRE_NAME} ACRE2Core ACRE2Shared x3daudio)
    set_target_properties(${ACRE_NAME} PROPERTIES FOLDER ACRE2 LINK_FLAGS -SAFESEH:NO)
else()
    target_link_libraries(${ACRE_NAME} ACRE2Core ACRE2Shared FAudio)
endif()
target_compile_features(${ACRE_NAME} PRIVATE cxx_std_17)


# Copy and rename
if(WIN32)
    if(USE_64BIT_BUILD)
        set(FINAL_DLL_NAME acre2_win64.dll)
    else()
        set(FINAL_DLL_NAME acre2_win32.dll)
    endif()
else()
    if(USE_64BIT_BUILD)
        set(FINAL_DLL_NAME acre2_x64.so)
    else()
        set(FINAL_DLL_NAME acre2_x86.so)
    endif()
endif()

add_custom_command(TARGET ${ACRE_NAME} POST_BUILD
    # Copy DLL to plugins
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${ACRE_NAME}> ${PROJECT_SOURCE_DIR}/../plugin/mumble/${FINAL_DLL_NAME}
    # Copy PDB to symbols
    COMMAND_EXPAND_LISTS
)

if(WIN32)
    add_custom_command(TARGET ${ACRE_NAME} POST_BUILD
        # Copy PDB to symbols
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${ACRE_NAME}>/${ACRE_NAME}.pdb ${PROJECT_SOURCE_DIR}/../symbols/${ACRE_ARCH}/${ACRE_NAME}.pdb
        COMMAND_EXPAND_LISTS
    )
endif()
