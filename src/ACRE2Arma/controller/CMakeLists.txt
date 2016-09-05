file(GLOB_RECURSE ACRE_CONTROLLER_SOURCES *.h *.hpp *.c *.cpp)

file(GLOB CONTROLLER_SOURCES *.h *.hpp *.c *.cpp)
acre_set_linker_options()



SOURCE_GROUP("main" FILES ${CONTROLLER_SOURCES})

add_library(acre_controller_static STATIC ${CONTROLLER_SOURCES})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})


target_link_libraries(acre_controller_static acre_common ${LINK_LIBS})
set_target_properties(acre_controller_static PROPERTIES PREFIX "")
set_target_properties(acre_controller_static PROPERTIES COMPILE_DEFINITIONS _STATIC)
set_target_properties(acre_controller_static PROPERTIES FOLDER ACRE2Arma)

if(CMAKE_COMPILER_IS_GNUCXX)
	set_target_properties(acre_controller_static PROPERTIES LINK_SEARCH_START_STATIC 1)
	set_target_properties(acre_controller_static PROPERTIES LINK_SEARCH_END_STATIC 1)
    set_target_properties(acre_controller_static PROPERTIES LINK_SEARCH_START_STATIC 1)
	set_target_properties(acre_controller_static PROPERTIES LINK_SEARCH_END_STATIC 1)
endif()
