
#include "Log.h"

#include <chrono>
#include <ctime>

Log *g_Log = nullptr;

Log::Log(char *logFile) { 
    InitializeCriticalSection(&this->m_CriticalSection);

    if (logFile == nullptr) {
        this->fileHandle = GetStdHandle(STD_OUTPUT_HANDLE);
        return;
    }

    this->fileHandle = CreateFileA(logFile, GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, 0, 0);
    if (this->fileHandle != INVALID_HANDLE_VALUE) {
        SetFilePointer(this->fileHandle, 0, NULL, FILE_END);

    } else {
        this->fileHandle = GetStdHandle(STD_OUTPUT_HANDLE);
        return;
    }
}

Log::~Log(void) {
    EnterCriticalSection(&this->m_CriticalSection);
    DeleteCriticalSection(&this->m_CriticalSection);
    CloseHandle(this->fileHandle);
}
size_t Log::Write(const acre::LogLevel msgType, char *function, const uint32_t line, const char *format, ...) {
    char buffer[4097], tbuffer[1024];
    va_list va;
    DWORD count;

    if (this == NULL) {
        return static_cast<size_t>(acre::LogLevel::Error);
    }

    if (this->fileHandle == INVALID_HANDLE_VALUE) {
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
    size_t ret = vsnprintf(tbuffer,sizeof(tbuffer), format, va);
    va_end(va);

    strncat(buffer, tbuffer, sizeof(buffer));

    ret = strlen(buffer) + 2;
    strncat(buffer, "\r\n", sizeof(buffer));

    EnterCriticalSection(&this->m_CriticalSection);
    const bool res = WriteFile(this->fileHandle, (LPCVOID)buffer, (DWORD)ret, &count, NULL);
    if (!res) {
        printf("Write file failed");
    }
    LeaveCriticalSection(&this->m_CriticalSection);

    // test debug, print it too
    printf("%s", buffer);

    if (msgType == acre::LogLevel::Error) {
        MessageBoxA(NULL, buffer, "CRITICAL ERROR", MB_OK);
    }

    return(ret);
}
size_t Log::PopMessage(const acre::LogLevel msgType, const char *format, ...) {
    char buffer[4097];
    va_list va;
        
    memset(buffer, 0x00, sizeof(buffer));
    va_start(va, format);
    int32_t ret = vsnprintf(buffer, 4096, format, va);
    va_end(va);

    ret = MessageBoxA(NULL, buffer, "Log Message", MB_ICONINFORMATION | MB_OK);

    return(ret);
}
