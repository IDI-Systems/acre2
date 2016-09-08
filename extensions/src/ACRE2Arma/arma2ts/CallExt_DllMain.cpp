#include "compat.h"
//#include "Log.h"
#include "macros.h"
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>
#include "shlobj.h"
#include "Shlwapi.h"
#include <algorithm> 
#include <functional> 
#include <cctype>
#include <locale>

// trim from start
static inline std::string &ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
    return s;
}

// trim from end
static inline std::string &rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
    return s;
}

// trim from both ends
static inline std::string &trim(std::string &s) {
    return ltrim(rtrim(s));
}

#pragma comment(lib, "shlwapi.lib")

#define PIPE_COMMAND_OPEN    0
#define PIPE_COMMAND_CLOSE    1
#define PIPE_COMMAND_WRITE    2
#define PIPE_COMMAND_READ    3
#define PIPE_COMMAND_RESET    4

#define FROM_PIPENAME_TS    "\\\\.\\pipe\\acre_comm_pipe_fromTS"
#define TO_PIPENAME_TS        "\\\\.\\pipe\\acre_comm_pipe_toTS"


HANDLE    writeHandle = INVALID_HANDLE_VALUE;
HANDLE    readHandle = INVALID_HANDLE_VALUE;

BOOL writeConnected, readConnected;



void ClosePipe();

extern "C" 
{
  __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function); 
};

inline std::string get_path() {
    char moduleName[MAX_PATH];
    GetModuleFileNameA(NULL, moduleName, MAX_PATH);
    return std::string(moduleName);
}

inline std::string get_cmdline() {
    return std::string(GetCommandLineA());
}

inline std::string get_path(std::string filepath) {
    char drive[_MAX_DRIVE];
    char dir [_MAX_DIR];
    
    _splitpath(
        filepath.c_str(),
        drive,
        dir,
        NULL,
        NULL
        );
    std::string path = std::string(drive) + std::string(dir);

    return path;
}

inline std::string get_quoted(std::string text) {
    std::string::size_type    start_position = 0;
    std::string::size_type    end_position = 0;
    std::string               found_text;

    start_position = text.find("\"");
    if (start_position != std::string::npos)
    {
        ++start_position; // start after the double quotes.
                          // look for end position;
        end_position = text.find("\"");
        if (end_position != std::string::npos)
        {
            found_text = text.substr(start_position, end_position - start_position);
        }
    }
    return found_text;
}
EXTERN_C IMAGE_DOS_HEADER __ImageBase;
inline std::string find_mod_file(std::string filename) {
    char module_path[MAX_PATH];
    GetModuleFileNameA((HINSTANCE)&__ImageBase, module_path, MAX_PATH);

    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];

    _splitpath(
        module_path,
        drive,
        dir,
        NULL,
        NULL
        );

    std::string path = std::string(drive) + std::string(dir) + "\\" + filename;
    if (!PathFileExistsA(path.c_str())) {
        // No mod path was set, it means they used the mod config. It *DOES* mean it relative to a folder in our path at least. 
        // So, we just search all the local folders

        WIN32_FIND_DATAA data;
        std::string path("*");
        std::string *name;
        HANDLE hFile = FindFirstFileA(path.c_str(), &data);

        if (hFile == INVALID_HANDLE_VALUE)
            return "";

        while (FindNextFile(hFile, &data) != 0 || GetLastError() != ERROR_NO_MORE_FILES) {
            if (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
                std::string fullpath = std::string(data.cFileName) + "\\" + filename;
                if (PathFileExistsA(fullpath.c_str())) {
                    path = fullpath;
                    break;
                }
            }
        }
    }
    return path;
}

void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
    size_t id_length = 1;
    std::string functionStr = std::string(function);
    
    if (functionStr.length() > 1) {
        if (isdigit(functionStr.substr(1, 1).c_str()[0])) {
            id_length = 2;
        }
    }

    std::string id = functionStr.substr(0, id_length);
    std::string params;
    if(functionStr.length() > 1) {
        params = functionStr.substr(id_length, functionStr.length() - id_length);
    }

    int command = atoi(id.c_str());

    switch(command) {
        
        case PIPE_COMMAND_WRITE: {
            if(writeConnected) {
                if(params.length() > 0) {
                    DWORD cbWritten;
                    BOOL ret;
                    //DEBUG("Writing [%s] to pipe [%d]\n", params.c_str(), hPipe);
            
                    // Send a message to the pipe server. 
                    ret = WriteFile( 
                    writeHandle,                  // pipe handle 
                    params.c_str(),                    // message 
                    params.length(),            // message length 
                    &cbWritten,             // bytes written 
                    NULL);                  // not overlapped 
                    if(cbWritten != params.length()) {
                        FlushFileBuffers(writeHandle);
                        //printf("FLUSHING!\n");
                    }
                    //printf("WriteFile: %d %d of %d\n", GetLastError(), cbWritten, params.length());
                    //FlushFileBuffers(hPipe);
                    if ( ! ret) {
                        //DEBUG("WriteFile failed, [%d]\n", GetLastError());
                        ClosePipe();
                        strncpy(output,"0",outputSize);
                        return;
                    }
                    strncpy(output,"1",outputSize);
                }
            } else {
                ClosePipe();
                strncpy(output,"-1",outputSize);
            }
            return;
        }
        case PIPE_COMMAND_READ: {
            if(readConnected) {
                DWORD cbRead;
                DWORD err;
                BOOL ret;
                char *value = new char[4096];
                //DEBUG("Read from pipe [%d]\n", hPipe);
                ret = ReadFile(readHandle, (LPVOID)value, 4096, &cbRead, NULL);
                if ( ! ret) {
                    err = GetLastError();
                    if (err == ERROR_BROKEN_PIPE) {
                        ClosePipe();
                    }
                    //DEBUG("ReadFile failed, [%08x]\r\n", err);
                }
                if(cbRead != 0) {
                    //DEBUG("Read data: %s\n", value);
                    strncpy(output,value,cbRead);
                } else {
                    if(err == 232) {
                        strncpy(output,"_JERR_NULL",outputSize);
                    } else {
                        //LOG("PIPE ERROR: %d\r\n", err);
                        strncpy(output,"_JERR_FALSE",outputSize);
                    }
                }
                delete value;
            } else {
                ClosePipe();
                strncpy(output,"_JERR_NOCONNECT",outputSize);
            }
            return;
        }
        case PIPE_COMMAND_OPEN: {
            BOOL ret;
            int tries = 0;
            if(readConnected || writeConnected) {
                ClosePipe();
                //Sleep(100);
            }
            std::string fromPipeName = FROM_PIPENAME_TS;
            std::string toPipeName = TO_PIPENAME_TS;
            
            if (readHandle != INVALID_HANDLE_VALUE) {
                CloseHandle(readHandle);
                readConnected = false;
            }
            if(!readConnected) {
                while (tries < 1) {
                    readHandle = CreateFileA( 
                        fromPipeName.c_str(),        // pipe name 
                        GENERIC_READ | GENERIC_WRITE, 
                        0,              // no sharing 
                        NULL,           // default security attributes
                        OPEN_EXISTING,  // opens existing pipe 
                        0,              // default attributes 
                        NULL);          // no template file 
                    if(readHandle != INVALID_HANDLE_VALUE) {
                        DWORD dwModeRead = PIPE_NOWAIT | PIPE_READMODE_MESSAGE;
                        ret = SetNamedPipeHandleState( 
                                readHandle,    // pipe handle 
                                &dwModeRead,  // new pipe mode 
                                NULL,     // don't set maximum bytes 
                                NULL);    // don't set maximum time 
                        if ( ! ret) {
                            //printf("READ PIPE MODE ERROR: %d\n", GetLastError());
                            sprintf(output, "Read SetNamedPipeHandleState WinErrCode: %d", GetLastError());
                            return;
                        }
                        //printf("READ CONNECTED\n");
                        readConnected = TRUE;
                        break;
                    } else {
                        if(GetLastError() == ERROR_PIPE_BUSY) {
                            //if (!WaitNamedPipeA(fromPipeName.c_str(), NMPWAIT_USE_DEFAULT_WAIT))
                                 tries++;
                        } else {
                            //printf("READ CONNECT ERROR: %d\n", GetLastError());
                            sprintf(output, "Read CreateFileA WinErrCode: %d", GetLastError());
                            return;
                        }
                    }
                }
                if(!readConnected) {
                    sprintf(output, "Read Loop CreateFileA WinErrCode: %d", GetLastError());
                    return;
                }
            }
            if (writeHandle != INVALID_HANDLE_VALUE) {
                CloseHandle(writeHandle);
                writeConnected = false;
            }
            if(!writeConnected) {
                tries = 0;
                while(tries < 1) {
                    writeHandle = CreateFileA( 
                        toPipeName.c_str(),        // pipe name 
                        GENERIC_WRITE | GENERIC_READ,
                        0,              // no sharing 
                        NULL,           // default security attributes
                        OPEN_EXISTING,  // opens existing pipe 
                        0,              // default attributes 
                        NULL);          // no template file 

                    if(writeHandle != INVALID_HANDLE_VALUE) {
                        DWORD dwModeWrite = PIPE_READMODE_MESSAGE;
                        ret = SetNamedPipeHandleState( 
                                writeHandle,    // pipe handle 
                                &dwModeWrite,  // new pipe mode 
                                NULL,     // don't set maximum bytes 
                                NULL);    // don't set maximum time 
                        if ( ! ret) {
                            //printf("WRITE PIPE MODE ERROR: %d\n", GetLastError());
                            sprintf(output, "Write SetNamedPipeHandleState WinErrCode: %d", GetLastError());
                            return;
                        }
                        writeConnected = TRUE;
                        break;
                        //printf("WRITE CONNECTED\n");
                    } else {
                        if(GetLastError() == ERROR_PIPE_BUSY) {
                            //if (!WaitNamedPipeA(fromPipeName.c_str(), NMPWAIT_USE_DEFAULT_WAIT))
                                 tries++;
                        } else {
                            sprintf(output, "Write CreateFileA WinErrCode: %d", GetLastError());
                            return;
                        }
                    }
                }
                if(!writeConnected) {
                    sprintf(output, "Write Loop CreateFileA WinErrCode: %d", GetLastError());
                    return;
                }
            }
            if(writeConnected && readConnected) {
                strncpy(output,"1",outputSize);
            } else {
                strncpy(output,"0",outputSize);
            }
            return;
        }
        case PIPE_COMMAND_CLOSE: {
            //printf("CLOSING\n");
            ClosePipe();
            return;
        }
        case PIPE_COMMAND_RESET: {
            ClosePipe();
            writeHandle = INVALID_HANDLE_VALUE;
            readHandle = INVALID_HANDLE_VALUE;
            return;
        }
        default:
            return;
    }
}

void ClosePipe() {

    if (writeHandle != INVALID_HANDLE_VALUE) {
        FlushFileBuffers(writeHandle);
        DisconnectNamedPipe(writeHandle);
        CloseHandle(writeHandle);
        writeHandle = INVALID_HANDLE_VALUE;
    }
    if (readHandle != INVALID_HANDLE_VALUE) {
        FlushFileBuffers(readHandle);
        DisconnectNamedPipe(readHandle);
        CloseHandle(readHandle);
        readHandle = INVALID_HANDLE_VALUE;
    }

    writeConnected = FALSE;
    readConnected = FALSE;
}


void Init(void) {
    //g_Log = (Log *)new Log("ACRE2Arma.log");
    //LOG("* Logging engine initialized.");
    writeConnected = FALSE;
    readConnected = FALSE;
}

void Cleanup(void) {

}


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        Init();
        break;
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        Cleanup();
        break;
    }
    return TRUE;
}
