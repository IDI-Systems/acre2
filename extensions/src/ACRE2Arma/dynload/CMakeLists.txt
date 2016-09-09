set(ACRE_EXTENSION_NAME "acre_dynload")
acre_set_linker_options()

file(GLOB SOURCES *.h *.hpp *.c *.cpp)
add_library( ${ACRE_EXTENSION_NAME} SHARED ${SOURCES} ${GLOBAL_SOURCES})
add_library( ${ACRE_EXTENSION_NAME}_static STATIC ${SOURCES} ${GLOBAL_SOURCES})

target_link_libraries(${ACRE_EXTENSION_NAME} acre_common)
set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES PREFIX "")
set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES FOLDER ACRE2Arma)
set_target_properties(${ACRE_EXTENSION_NAME}_static PROPERTIES FOLDER ACRE2Arma)


if(CMAKE_COMPILER_IS_GNUCXX)
    set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES LINK_SEARCH_START_STATIC 1)
    set_target_properties(${ACRE_EXTENSION_NAME} PROPERTIES LINK_SEARCH_END_STATIC 1)
endif()
