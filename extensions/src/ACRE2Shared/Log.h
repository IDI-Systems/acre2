#pragma once

#include "compat.h"
#include <cstdint>

namespace acre {
    enum class LogLevel : uint32_t {
        Trace = 0x00000001,
        Debug = 0x00000002,
        Info = 0x10000001,
        Error = 0xF0000001,
        Critical = 0xFFFFFFFF
    };
} /* namespace acre */

#ifdef _TRACE
    #define RUNNING_LOGLEVEL acre::LogLevel::Trace
    #define TRACE(...) g_Log->Write(acre::LogLevel::Trace, __FUNCTION__, __LINE__, __VA_ARGS__, NULL)
#else
    #define TRACE(...) 
#endif

#ifdef _REF_TRACE
    #define REF_TRACE(...) g_Log->Write(acre::LogLevel::Trace, __FUNCTION__, __LINE__, __VA_ARGS__, NULL)
#else
    #define REF_TRACE(...)
#endif

#ifdef _DEBUG
    #ifndef _TRACE
        #define RUNNING_LOGLEVEL acre::LogLevel::Debug
        #define DEBUG(...) g_Log->Write(acre::LogLevel::Debug, __FUNCTION__, __LINE__, __VA_ARGS__, NULL)
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
    #define LOG(...) g_Log->Write(acre::LogLevel::Info, __FUNCTION__, __LINE__, __VA_ARGS__, NULL)
#else
    #define LOG(...) g_Log->Write(acre::LogLevel::Info, NULL, NULL, __VA_ARGS__, NULL)
#endif

#ifdef _TRACE
#define ERR_ASSERT(...)                                                            \
    g_Log->Write(acre::LogLevel::Error, __FUNCTION__, __LINE__, __VA_ARGS__, NULL); \
    assert(1==2)
#else
#define ERR_ASSERT(...)                                                            \
    g_Log->Write(acre::LogLevel::Error, __FUNCTION__, __LINE__, __VA_ARGS__, NULL); 
#endif

#define TRACE_FUNCTION(x) x  { TRACE("enter");

class Log {
public:
    Log(char *logFile);
    ~Log(void);

    size_t Write(const acre::LogLevel msgType, char *function, const uint32_t line, const char *format, ...);
    size_t PopMessage(const acre::LogLevel msgType, const char *format, ...);

    HANDLE fileHandle;

private:
    
    CRITICAL_SECTION m_CriticalSection;
};

extern Log *g_Log;
