include_directories ("${PROJECT_SOURCE_DIR}")
acre_set_linker_options()

add_executable( mapgen mapgen.cpp)
add_executable( fakewrpgen fakewrpgen.cpp)

target_link_libraries(mapgen acre_common acre_controller_static acre_data_static acre_signal_static ${LINK_LIBS})
add_dependencies(mapgen acre_common acre_controller_static acre_data_static acre_signal_static)
SET_TARGET_PROPERTIES(mapgen PROPERTIES PREFIX "")
set_target_properties(mapgen PROPERTIES FOLDER Utils)


target_link_libraries(fakewrpgen acre_common ${LINK_LIBS})
add_dependencies(fakewrpgen acre_common )
SET_TARGET_PROPERTIES(fakewrpgen PROPERTIES PREFIX "")
set_target_properties(fakewrpgen PROPERTIES FOLDER Utils)
