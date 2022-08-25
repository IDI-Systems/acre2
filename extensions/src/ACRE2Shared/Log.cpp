
#include "Log.h"

#include <chrono>
#include <ctime>

#ifdef __linux
#include <stdarg.h>
#include <string.h>
#define strncat(x, y, z) strncat(x, y, z - 1)
#endif

Log *g_Log = nullptr;

Log::Log(const char * const logFile) {
   
    if (logFile == nullptr) {
        return;
    }

    this->logOutput.open(logFile, std::ios_base::out | std::ios_base::app);
}

Log::~Log(void) {
    std::unique_lock<std::mutex> lock(m_criticalMutex, std::defer_lock);
    lock.lock();
    lock.unlock();
    if (logOutput.is_open()) {
        logOutput.close();
    }
}
size_t Log::Write(const acre::LogLevel msgType, const char *function, const uint32_t line, const char *format, ...) {
    char buffer[4097], tbuffer[1024];
    va_list va;

    if (this == NULL) {
        return static_cast<size_t>(acre::LogLevel::Error);
    }

    if (!this->logOutput.is_open()) {
        return static_cast<size_t>(acre::LogLevel::Error);
    }

    buffer[0] = 0x00;

    const std::chrono::system_clock::time_point systemClock = std::chrono::system_clock::now();
    const std::time_t logTime = std::chrono::system_clock::to_time_t(systemClock);
    struct tm *localTime = localtime(&logTime);

    // Get the milliseconds
    const std::chrono::duration<double> timeSinceEpoch = systemClock.time_since_epoch();
    std::chrono::seconds::rep milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(timeSinceEpoch).count() % 1000;

    snprintf(buffer, sizeof(buffer) - 1, "[%d:%d:%d.%d] ", localTime->tm_hour, localTime->tm_min, localTime->tm_sec, milliseconds);

#ifdef _TRACE
    tbuffer[0] = 0x00;
    snprintf(tbuffer, sizeof(tbuffer) - 1, "(%s():%d) - ", function, line);
    strncat(buffer, tbuffer, sizeof(tbuffer));
    tbuffer[0] = 0x00;
#endif

    va_start(va, format);
    size_t ret = vsnprintf(tbuffer, sizeof(tbuffer), format, va);
    va_end(va);

    strncat(buffer, tbuffer, sizeof(buffer));

    ret = strlen(buffer) + 2;
    strncat(buffer, "\r\n", sizeof(buffer));

    std::unique_lock<std::mutex> lock(m_criticalMutex, std::defer_lock);
    lock.lock();
    this->logOutput.write(buffer, ret);
    this->logOutput.flush();
    lock.unlock();
   
    // test debug, print it too
    printf("%s", buffer);

#ifdef WIN32
    if (msgType == acre::LogLevel::Error) {
        MessageBoxA(NULL, buffer, "CRITICAL ERROR", MB_OK);
    }
#endif

    return(ret);
}
size_t Log::PopMessage(const acre::LogLevel msgType, const char *format, ...) {
    char buffer[4097];
    va_list va;
        
    memset(buffer, 0x00, sizeof(buffer));
    va_start(va, format);
    int32_t ret = vsnprintf(buffer, 4096, format, va);
    va_end(va);

#ifdef WIN32
    ret = MessageBoxA(NULL, buffer, "Log Message", MB_ICONINFORMATION | MB_OK);
#endif

    return(ret);
}
