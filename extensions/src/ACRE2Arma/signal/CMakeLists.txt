file(GLOB_RECURSE ACRE_SIGNAL_SOURCES *.h *.hpp *.c *.cpp)

file(GLOB SIGNAL_SOURCES *.h *.hpp *.c *.cpp)
acre_set_linker_options()



file(GLOB SIGNAL_SOURCES *.h *.hpp *.c *.cpp)
file(GLOB MAP_SOURCES map/*.h map/*.hpp map/*.c map/*.cpp)
file(GLOB ANTENNA_SOURCES antenna/*.h antenna/*.hpp antenna/*.c antenna/*.cpp)
file(GLOB MODEL_SOURCES models/*.h models/*.hpp models/*.c models/*.cpp)



SOURCE_GROUP("main" FILES ${SIGNAL_SOURCES})
#SOURCE_GROUP("debug" FILES ${DEBUG_SOURCES})
SOURCE_GROUP("map" FILES ${MAP_SOURCES})
SOURCE_GROUP("antenna" FILES ${ANTENNA_SOURCES})
SOURCE_GROUP("models" FILES ${MODEL_SOURCES})

add_library(acre_signal_static STATIC ${GLOBAL_SOURCES} ${SIGNAL_SOURCES} ${MAP_SOURCES} ${ANTENNA_SOURCES} ${MODEL_SOURCES})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})


target_link_libraries(acre_signal_static acre_controller_static acre_common ${LINK_LIBS})
set_target_properties(acre_signal_static PROPERTIES PREFIX "")
set_target_properties(acre_signal_static PROPERTIES COMPILE_DEFINITIONS _STATIC)
set_target_properties(acre_signal_static PROPERTIES FOLDER ACRE2Arma)

if(CMAKE_COMPILER_IS_GNUCXX)
    set_target_properties(acre_signal_static PROPERTIES LINK_SEARCH_START_STATIC 1)
    set_target_properties(acre_signal_static PROPERTIES LINK_SEARCH_END_STATIC 1)
    set_target_properties(acre_signal_static PROPERTIES LINK_SEARCH_START_STATIC 1)
    set_target_properties(acre_signal_static PROPERTIES LINK_SEARCH_END_STATIC 1)
endif()
