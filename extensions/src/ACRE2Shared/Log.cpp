// TODO: Remove comments that depend on windows routines
#include "compat.h"
#include "Log.h"
#include <cstring>

Log *g_Log = NULL;

Log::Log(char *logFile) {
    InitializeCriticalSection(&this->m_CriticalSection);

    if (logFile == NULL) {
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
size_t Log::Write(uint32_t msgType, char *function, unsigned int line, const char *format, ...) {
    char buffer[4097], tbuffer[1024];
    va_list va;
    size_t ret;
    uint32_t count;
    bool res;
#if WIN32
    SYSTEMTIME st;
#else
    struct timeval tv;
    struct tm* ptm;
    suseconds_t milliseconds;
#endif

    if (this == NULL) {
        return 0xFFFFFFFF;
    }

    if (this->fileHandle == INVALID_HANDLE_VALUE) {
        return 0xFFFFFFFF;
    }

    buffer[0] = 0x00;

#if WIN32
    GetLocalTime(&st);
    snprintf(buffer, sizeof(buffer), "[%d:%d:%d.%d] ", st.wHour, st.wMinute, st.wSecond, st.wMilliseconds);
#else
    gettimeofday(&tv, NULL);
    ptm = localtime(&tv.tv_sec);
    milliseconds = tv.tv_usec / 1000;
    snprintf(buffer, sizeof(buffer), "[%d:%d:%d.%d] ", ptm->tm_hour, ptm->tm_min, ptm->tm_sec, (uint32_t) milliseconds);
#endif

#ifdef _TRACE
    tbuffer[0] = 0x00;
    snprintf(tbuffer, sizeof(tbuffer)-1, "(%s():%d) - ", function, line);
    strncat(buffer, tbuffer,  sizeof(buffer));
    tbuffer[0] = 0x00;
#endif

    va_start(va, format);
    ret = vsnprintf(tbuffer,sizeof(tbuffer), format, va);
    va_end(va);

    strncat(buffer, tbuffer, sizeof(buffer));

    ret = strlen(buffer) + 2;
    strncat(buffer, "\r\n", sizeof(buffer));

#if WIN32
    EnterCriticalSection(&this->m_CriticalSection);
    res = WriteFile(this->fileHandle, (LPCVOID)buffer, (uint32_t) ret, &count, NULL);
    if (res == false) {
        printf("Write file failed");
    }
    LeaveCriticalSection(&this->m_CriticalSection);

    // test debug, print it too
    printf("%s", buffer);

    if (msgType == LOGLEVEL_ERROR) {
        MessageBoxA(NULL, buffer, "CRITICAL ERROR", MB_OK);
    }
#endif

    return(ret);
}
size_t Log::PopMessage(uint32_t msgType, const char *format, ...) {
    char buffer[4097];
    va_list va;
    int ret;

    msgType = msgType;

    memset(buffer, 0x00, sizeof(buffer));
    va_start(va, format);
    ret = vsnprintf(buffer,4096, format, va);
    va_end(va);

#if WIN32
    ret = MessageBoxA(NULL, buffer, "Log Message", MB_ICONINFORMATION | MB_OK);
#endif

    return (ret);
}
