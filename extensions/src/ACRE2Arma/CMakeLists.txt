cmake_minimum_required (VERSION 3.0)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if(WIN32)
add_definitions(/DWINVER=0x0600 /D_WIN32_WINNT=0x0600)
endif()

if (NOT CMAKE_BUILD_TYPE AND CMAKE_COMPILER_IS_GNUCXX)
    message(STATUS "No build type selected, default to Debug")
    set(CMAKE_BUILD_TYPE "Debug")
endif()

option(DEVEL "DEVEL" ON)
option(USE_BULLET "USE_BULLET" ON)
option(USE_DIRECTX "USE_DIRECTX" ON)
option(USE_64BIT_BUILD "USE_64BIT_BUILD" OFF)
option(USE_STATIC_LINKING "USE_STATIC_LINKING" ON)


if(CMAKE_COMPILER_IS_GNUCXX)
    SET(CMAKE_CXX_FLAGS "-march=i686 -m32 -O2 -s -std=c++11 -Wall -W -Wextra -Wmissing-prototypes -Wstrict-prototypes -Wbad-function-cast -Wundef -Wconversion -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wnested-externs -Wstrict-overflow=5 -fshort-enums -fno-common -fPIC ")
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    set(CMAKE_SHARED_LINKER_FLAGS "-static-libgcc -static-libstdc++")
else()
    set(CMAKE_CXX_FLAGS_DEBUG "/D _DEBUG /MTd /Zi /Ob0 /Od /RTC1 /EHsc")
    set(CMAKE_CXX_FLAGS_MINSIZEREL     "/MT /O1 /Ob1 /D /EHsc NDEBUG")
    set(CMAKE_CXX_FLAGS_RELEASE       "/MT /O2 /Ob2 /D /EHsc NDEBUG")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "/MT /Zi /O2 /Ob1 /D /EHsc NDEBUG")
endif()

include_directories("common")
include_directories("controller")
include_directories("data")
include_directories("signal")
include_directories("acre")
include_directories("lib/lzo/include")

if(USE_DIRECTX)
    add_definitions(-DUSE_DIRECTX)
    set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
    find_package (DirectX)
    link_directories (BEFORE ${DirectX_D3DX11_LIBRARY})
    include_directories (BEFORE ${DirectX_D3DX11_INCLUDE_DIR} )
endif()
if(DEVEL)
    add_definitions(-DDEVEL)
endif()

include_directories(${CMAKE_CURRENT_BINARY_DIR}/common)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/controller)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/data)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/signal)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/acre)

set(GLOBAL_SOURCES ${GLOBAL_RC})

# Add extensions to build here
add_subdirectory(common)
add_subdirectory(controller)
add_subdirectory(data)
add_subdirectory(arma2ts)
add_subdirectory(signal)
add_subdirectory(acre)

add_subdirectory(tests)
add_subdirectory(utils)

# Extensions

# Test Extension for dynamically loading/unloading built extensions; does not build in release
if (DEVEL)
    add_subdirectory(dynload)
    #add_subdirectory(tests)
endif()

message("Build Type: ${CMAKE_BUILD_TYPE}")
