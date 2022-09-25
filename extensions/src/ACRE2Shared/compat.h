#pragma once

//#define NTDDI_VERSION NTDDI_WINXPSP3
//#define _WIN32_WINNT _WIN32_WINNT_WINXP
//#define WINVER _WIN32_WINNT_WINXP

#ifdef _DEBUG
    #define _ACRE_DEBUG_HEAP
#endif

#pragma warning(disable : 4366)

#ifdef WIN32
    #define _WINSOCKAPI_
    #define NOMINMAX
    #include <Windows.h>
    #include <winsock2.h>
    #include <tchar.h>
#endif

#include <stdio.h>
#include <time.h>
#include <cstring>
#include <stdarg.h>

#ifdef _ACRE_DEBUG_HEAP
    #define _CRTDBG_MAP_ALLOC
    #include <assert.h>
    #include <crtdbg.h>
#endif

/*
// only pragma lib the non-lib builds
#ifndef _LIB
    #pragma comment(lib, "ws2_32.lib")
    #pragma comment(lib, "advapi32.lib")

    #ifdef _WIN64
    #pragma comment(lib, "..\\..\\ACRE2Shared\\bin\\ACRE2Shared_x64.lib")
    #else
    #pragma comment(lib, "..\\..\\ACRE2Shared\\bin\\ACRE2Shared_x86.lib")
    #endif

#ifndef _NOCORE
    #ifdef _WIN64
    #pragma comment(lib, "..\\..\\ACRE2Core\\bin\\ACRE2Core_x64.lib")
    #else
    #pragma comment(lib, "..\\..\\ACRE2Core\\bin\\ACRE2Core_x86.lib")
    #endif
#endif
#endif
    */
//#include "Exception.h"
#include "_CONSTANTS.h"

#ifdef WIN32
#define PATH_SEPARATOR "\\"

#else

#include <climits>
#include <cstdint>
#include <unistd.h>

#define PATH_SEPARATOR "/"

#define TRUE true
#define FALSE false
typedef int BOOL;
typedef uint32_t DWORD;

#define MAXSHORT SHRT_MAX
#define MINSHORT SHRT_MIN

#define LocalAlloc(x, y) calloc(1, y)
#define LocalFree free
#define LocalReAlloc(x, y, z) realloc(x, y)
#define GetLastError() errno
#define Sleep(x) usleep(x * 1000)

#endif
