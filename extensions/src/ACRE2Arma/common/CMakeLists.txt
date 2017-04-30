file(GLOB_RECURSE ACRE_COMMON_SOURCES *.h *.hpp *.c *.cc *.cpp)
acre_set_linker_options()


file(GLOB ACRE_BASE_COMMON_SOURCES *.h *.hpp *.c *.cc *.cpp)
file(GLOB ACRE_P3D_SOURCES  p3d/*.h p3d/*.hpp p3d/*.c p3d/*.cpp)
file(GLOB ACRE_PBO_SOURCES  pbo/*.h pbo/*.hpp pbo/*.c pbo/*.cpp)
file(GLOB ACRE_SIMULATION_SOURCES simulation/*.h simulation/*.hpp simulation/*.c simulation/*.cpp)
file(GLOB ACRE_DIRECTX_SOURCES directx/*.h directx/*.hpp directx/*.c directx/*.cpp)
file(GLOB ACRE_GLM_SOURCES glm/*.h glm/*.hpp glm/*.c glm/*.cpp)
file(GLOB ACRE_WRP_SOURCES wrp/*.h wrp/*.hpp wrp/*.c wrp/*.cpp)
file(GLOB ACRE_SQF_SOURCES sqf/*.h sqf/*.hpp sqf/*.c sqf/*.cpp)



SOURCE_GROUP("common" FILES ${ACRE_BASE_COMMON_SOURCES})
SOURCE_GROUP("p3d" FILES ${ACRE_P3D_SOURCES})
SOURCE_GROUP("pbo" FILES ${ACRE_PBO_SOURCES})
SOURCE_GROUP("simulation" FILES ${ACRE_SIMULATION_SOURCES})
SOURCE_GROUP("directx" FILES ${ACRE_DIRECTX_SOURCES})
SOURCE_GROUP("glm" FILES ${ACRE_GLM_SOURCES})
SOURCE_GROUP("wrp" FILES ${ACRE_WRP_SOURCES})
SOURCE_GROUP("sqf" FILES ${ACRE_SQF_SOURCES})





add_library(acre_common STATIC ${ACRE_SQF_SOURCES} ${ACRE_WRP_SOURCES} ${ACRE_GLM_SOURCES} ${ACRE_BASE_COMMON_SOURCES} ${ACRE_P3D_SOURCES} ${ACRE_PBO_SOURCES} ${ACRE_SIMULATION_SOURCES} ${ACRE_DIRECTX_SOURCES})

set_target_properties(acre_common PROPERTIES FOLDER ACRE2Arma)
