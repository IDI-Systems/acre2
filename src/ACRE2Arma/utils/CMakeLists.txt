include_directories ("${PROJECT_SOURCE_DIR}")
add_executable( mapgen mapgen.cpp)
acre_set_linker_options()
target_link_libraries(mapgen acre_common acre_controller_static acre_data_static acre_signal_static ${LINK_LIBS})
add_dependencies(mapgen acre_common acre_controller_static acre_data_static acre_signal_static)
SET_TARGET_PROPERTIES(mapgen PROPERTIES PREFIX "")
set_target_properties(mapgen PROPERTIES FOLDER Utils)

