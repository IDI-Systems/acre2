cmake_minimum_required (VERSION 3.0)

set(ACRE_EXTENSION_NAME "acre")

file(GLOB_RECURSE ACRE_SOURCES *.h *.hpp *.c *.cpp)
acre_set_linker_options()

set(ACRE_NAME "acre")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}acre")

file(GLOB ACRE_SOURCES *.h *.hpp *.c *.cpp)

SOURCE_GROUP("main" FILES ${ACRE_SOURCES})

add_library( ${ACRE_EXTENSION_NAME} SHARED ${ACRE_SOURCES})
add_library( ${ACRE_EXTENSION_NAME}_static STATIC ${ACRE_SOURCES})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})


target_link_libraries(${ACRE_EXTENSION_NAME} acre_common acre_controller_static acre_data_static acre_signal_static ${LINK_LIBS})
set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES PREFIX "")
#set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES COMPILE_DEFINITIONS _DLL)
set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES FOLDER ACRE2Arma)

target_link_libraries(${ACRE_EXTENSION_NAME}_static acre_common acre_controller_static acre_data_static acre_signal_static ${LINK_LIBS})
set_target_properties(${ACRE_EXTENSION_NAME}_static PROPERTIES PREFIX "")
set_target_properties(${ACRE_EXTENSION_NAME}_static PROPERTIES COMPILE_DEFINITIONS _STATIC)
set_target_properties(${ACRE_EXTENSION_NAME}_static PROPERTIES FOLDER ACRE2Arma)

if(CMAKE_COMPILER_IS_GNUCXX)
    set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES LINK_SEARCH_START_STATIC 1)
    set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES LINK_SEARCH_END_STATIC 1)
    set_target_properties(${ACRE_EXTENSION_NAME}_static PROPERTIES LINK_SEARCH_START_STATIC 1)
    set_target_properties(${ACRE_EXTENSION_NAME}_static PROPERTIES LINK_SEARCH_END_STATIC 1)
endif()

# Copy to root
if(USE_64BIT_BUILD)
    add_custom_command(TARGET ${ACRE_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${ACRE_NAME}> ${PROJECT_SOURCE_DIR}/../acre_64.dll
    )
else()
    add_custom_command(TARGET ${ACRE_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${ACRE_NAME}> ${PROJECT_SOURCE_DIR}/../$<TARGET_FILE_NAME:${ACRE_NAME}>
    )
endif()
