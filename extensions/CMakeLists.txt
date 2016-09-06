cmake_minimum_required (VERSION 3.0)
project (ACRE)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/CMakeModules)
include(${PROJECT_SOURCE_DIR}/CMakeModules/cxx_compiler_functions.cmake)

find_package(DirectX)
if(DirectX_FOUND)
message("Found DirectX")
else()
message(FATAL_ERROR "DirectX NOT FOUND")
endif()

option(USE_64BIT_BUILD "USE_64BIT_BUILD" OFF)
option(USE_STATIC_LINKING "USE_STATIC_LINKING" ON)
option(USE_ACRE2UI "USE_ACRE2UI" ON)
option(USE_ACRE311 "USE_ACRE311" OFF)

if(USE_STATIC_LINKING)
    message("WARNING: Linking statically")
    set(ACRE_LINK_TYPE "static")
else()
    message("WARNING: Linking dynamically")
    set(ACRE_LINK_TYPE "dynamic")
endif()

message("GENERATOR USED: '${CMAKE_GENERATOR}'")

if(USE_64BIT_BUILD)
    message("WARNING: Building 64-bit projects")
    set(ACRE_ARCH "x64")
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/build/win64/")
    link_directories("${DirectX_ROOT_DIR}/lib/x64")
else()
    message("WARNING: Building 32-bit projects")
    set(ACRE_ARCH "x86")
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/build/win32/")
    link_directories("${DirectX_ROOT_DIR}/lib/x86")
endif()

SET(CMAKE_INCLUDE_CURRENT_DIR ON)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

include_directories(src/ACRE2Shared)
include_directories(src/ACRE2Core)

# ACRE2 Core Functionality
add_subdirectory(src/ACRE2Shared)
add_subdirectory(src/ACRE2Core)

add_subdirectory(src/ACRE2Arma)
add_subdirectory(src/ACRE2Steam)

if(USE_ACRE2UI)
    if(USE_ACRE311)
        add_subdirectory(src/ACRE2UI311)
    endif()
    add_subdirectory(src/ACRE2UI)
endif()

add_subdirectory(src/ACRE2TS)
if(USE_ACRE311)
    add_subdirectory(src/ACRE2TS311)
endif()

#Extras
add_subdirectory(src/Wav2B64)
add_subdirectory(src/ACRE2DistortionTestPlugin)
