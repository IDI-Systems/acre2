#pragma once

#include "compat.h"
#include <cstdint>
#include <stdarg.h>

#define LOGLEVEL_TRACE        0x00000001
#define LOGLEVEL_DEBUG        0x00000002
#define LOGLEVEL_INFO        0x10000001
#define LOGLEVEL_ERROR        0xF0000001
#define LOGLEVEL_CRITICAL    0xFFFFFFFF

#ifdef _TRACE
    #define RUNNING_LOGLEVEL LOGLEVEL_TRACE
    #define TRACE(...) g_Log->Write(LOGLEVEL_TRACE, __FUNCTION__, __LINE__, __VA_ARGS__, NULL)
#else
    #define TRACE(...)
#endif

#ifdef _REF_TRACE
    #define REF_TRACE(...) g_Log->Write(LOGLEVEL_TRACE, __FUNCTION__, __LINE__, __VA_ARGS__, NULL)
#else
    #define REF_TRACE(...)
#endif

#ifdef _DEBUG
    #ifndef _TRACE
        #define RUNNING_LOGLEVEL LOGLEVEL_DEBUG
        #define DEBUG(...) g_Log->Write(LOGLEVEL_DEBUG, __FUNCTION__, __LINE__, __VA_ARGS__, NULL)
    #else
        #define DEBUG(...)
    #endif
#else
#define DEBUG(...)
#endif

#ifndef _DEBUG
    #ifndef _TRACE
        #define RUNNING_LOGLEVEL_INFO
    #endif
#endif

#ifdef _TRACE
    #define LOG(...) g_Log->Write(LOGLEVEL_INFO, __FUNCTION__, __LINE__, __VA_ARGS__, NULL)
#else
    #define LOG(...) g_Log->Write(LOGLEVEL_INFO, NULL, NULL, __VA_ARGS__, NULL)
#endif

#ifdef _TRACE
#define ERR_ASSERT(...)                                                            \
    g_Log->Write(LOGLEVEL_ERROR, __FUNCTION__, __LINE__, __VA_ARGS__, NULL); \
    assert(1==2)
#else
#define ERR_ASSERT(...)                                                            \
    g_Log->Write(LOGLEVEL_ERROR, __FUNCTION__, __LINE__, __VA_ARGS__, NULL);
#endif

#define TRACE_FUNCTION(x) x  { TRACE("enter");

class Log
{
public:
    Log(char *logFile);
    ~Log(void);

    size_t Write(uint32_t msgType, char *function, unsigned int line, const char *format, ...);
    size_t PopMessage(uint32_t msgType, const char *format, ...);

    HANDLE fileHandle;

private:
    CRITICAL_SECTION m_CriticalSection;
};

extern Log *g_Log;
