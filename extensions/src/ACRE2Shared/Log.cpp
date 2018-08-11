
#include "compat.h"
#include "Log.h"


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
size_t Log::Write(DWORD msgType, char *function, const uint32_t ac_line, const char *format, ...) {
    char buffer[4097], tbuffer[1024];
    va_list va;
    size_t ret;
    DWORD count;
    BOOL res;
    SYSTEMTIME st;

    if (this == NULL)
        return 0xFFFFFFFF;

    if (this->fileHandle == INVALID_HANDLE_VALUE) 
        return 0xFFFFFFFF;

    buffer[0] = 0x00;

    GetLocalTime(&st);
    _snprintf_s(buffer, sizeof(buffer), sizeof(buffer)-1, "[%d:%d:%d.%d] ", st.wHour, st.wMinute, st.wSecond, st.wMilliseconds);

#ifdef _TRACE
    tbuffer[0] = 0x00;
    _snprintf_s(tbuffer, sizeof(tbuffer)-1, sizeof(tbuffer)-1, "(%s():%d) - ", function, line);
    strcat_s(buffer, sizeof(buffer), tbuffer);
    tbuffer[0] = 0x00;
#endif

    va_start(va, format);
    ret = vsprintf_s(tbuffer,sizeof(tbuffer), format, va);
    va_end(va);

    strcat_s(buffer, sizeof(buffer), tbuffer);

    ret = strlen(buffer)+2;
    strcat_s(buffer, sizeof(buffer), "\r\n");

    EnterCriticalSection(&this->m_CriticalSection);
    res = WriteFile(this->fileHandle, (LPCVOID)buffer, (DWORD)ret, &count, NULL);
    if (res == FALSE) {
        printf("Write file failed");
    }
    LeaveCriticalSection(&this->m_CriticalSection);

    // test debug, print it too
    printf("%s", buffer);

    if (msgType == LOGLEVEL_ERROR) {
        MessageBoxA(NULL, buffer, "CRITICAL ERROR", MB_OK);
    }

    return(ret);
}
size_t Log::PopMessage(DWORD msgType, const char *format, ...) {
    char buffer[4097];
    va_list va;
    int ret;
    
    msgType = msgType;

    memset(buffer, 0x00, sizeof(buffer));
    va_start(va, format);
    ret = vsprintf_s(buffer,4096, format, va);
    va_end(va);

    ret = MessageBoxA(NULL, buffer, "Log Message", MB_ICONINFORMATION | MB_OK);

    return(ret);
}
