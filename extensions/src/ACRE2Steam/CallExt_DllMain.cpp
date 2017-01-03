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

#define STEAM_CHECK        0
#define STEAM_GET_PATH    1
#define STEAM_DO_COPY    2


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

inline std::string find_mod_folder() {
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

    std::string path = std::string(drive) + std::string(dir);
    return path;
}

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

    std::string path = std::string(drive) + std::string(dir) + filename;
    if (!PathFileExistsA(path.c_str())) {
        // No mod path was set, it means they used the mod config. It *DOES* mean it relative to a folder in our path at least. 
        // So, we just search all the local folders

        WIN32_FIND_DATAA data;
        std::string path("");
        std::string *name;
        HANDLE hFile = FindFirstFileA(path.c_str(), &data);

        if (hFile == INVALID_HANDLE_VALUE)
            return "";

        while (FindNextFile(hFile, &data) != 0 || GetLastError() != ERROR_NO_MORE_FILES) {
            if (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
                std::string fullpath = std::string(data.cFileName) + filename;
                if (PathFileExistsA(fullpath.c_str())) {
                    path = fullpath;
                    break;
                }
            }
        }
    }
    return path;
}

std::string ReadRegValue(HKEY root, std::string key, std::string name)
{
    HKEY hkey;
    if (RegOpenKeyExA(root, key.c_str(), 0, KEY_READ, &hkey) != ERROR_SUCCESS)
        return "";

    DWORD type;
    DWORD cbData;
    if (RegQueryValueExA(hkey, name.c_str(), NULL, &type, NULL, &cbData) != ERROR_SUCCESS)
    {
        RegCloseKey(hkey);
        return "";
    }

    if (type != REG_SZ)
    {
        RegCloseKey(hkey);
        return "";
    }

    std::string value(cbData / sizeof(char), '\0');
    if (RegQueryValueExA(hkey, name.c_str(), NULL, NULL, reinterpret_cast<LPBYTE>(&value[0]), &cbData) != ERROR_SUCCESS)
    {
        RegCloseKey(hkey);
        return "";
    }

    RegCloseKey(hkey);

    size_t firstNull = value.find_first_of('\0');
    if (firstNull != std::string::npos)
        value.resize(firstNull);

    return value;
}

std::string ReadRegValue64(HKEY root, std::string key, std::string name)
{
    HKEY hkey;
    if (RegOpenKeyExA(root, key.c_str(), 0, KEY_READ | KEY_WOW64_64KEY, &hkey) != ERROR_SUCCESS)
        return "";

    DWORD type;
    DWORD cbData;
    if (RegQueryValueExA(hkey, name.c_str(), NULL, &type, NULL, &cbData) != ERROR_SUCCESS)
    {
        RegCloseKey(hkey);
        return "";
    }

    if (type != REG_SZ)
    {
        RegCloseKey(hkey);
        return "";
    }

    std::string value(cbData / sizeof(char), '\0');
    if (RegQueryValueExA(hkey, name.c_str(), NULL, NULL, reinterpret_cast<LPBYTE>(&value[0]), &cbData) != ERROR_SUCCESS)
    {
        RegCloseKey(hkey);
        return "";
    }

    RegCloseKey(hkey);

    size_t firstNull = value.find_first_of('\0');
    if (firstNull != std::string::npos)
        value.resize(firstNull);

    return value;
}

void write_config(std::string version, int skip) {
    std::string mod_folder = find_mod_folder();
    std::string config_path = mod_folder + "acresteamconfig";
    std::ofstream config_file(config_path);
    if (config_file.is_open()) {
        config_file << version << "\n";
        config_file << skip << "\n";
    }
    else {
        int result = MessageBoxA(NULL, "ACRE was unable to write the Steam Workshop configuration file to the mod folder. Please check permissions on the folder.", "ACRE Installation Error", MB_OK | MB_ICONEXCLAMATION);
    }
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
    if (functionStr.length() > 1) {
        params = functionStr.substr(id_length, functionStr.length() - id_length);
    }

    int command = atoi(id.c_str());

    switch(command) {
        
        case STEAM_CHECK: {
            strncpy(output, "1", outputSize);
            return;
        }
        case STEAM_GET_PATH: {
            std::string path = find_mod_file("ACRE2Steam.dll");
            path = ReadRegValue(HKEY_LOCAL_MACHINE, "SOFTWARE\\TeamSpeak 3 Client", "");
            strncpy(output, path.c_str(), outputSize);
            return;
        }
        case STEAM_DO_COPY: {
            std::string current_version = params;
            std::string version;
            std::string skip_str;
            bool skip = false;
            std::string path_config = find_mod_file("acresteamconfig");
            if (path_config != "") {
                std::ifstream config(path_config);
                if (config.is_open())
                {
                    if (std::getline(config, version)) {
                        if (std::getline(config, skip_str)) {
                            if (skip_str == "1") {
                                skip = true;
                            }
                        }
                    }
                }
            }
            if (current_version != version) {
                skip = false;
            }
            if (skip) {
                strncpy(output, "[0]", outputSize);
                return;
            }


            std::string path_x86 = find_mod_file("plugin\\acre2_win32.dll");
            if (path_x86 == "") {
                int result = MessageBoxA(NULL, "ACRE was unable to find x86 Teamspeak plugin file. The ACRE installation is corrupted. Please reinstall from Steam Workshop.", "ACRE Installation Error", MB_OK | MB_ICONERROR);
                //strncpy(output, "[-1]", outputSize);
                TerminateProcess(GetCurrentProcess(), 0);
                return;
            }

            std::string path_x64 = find_mod_file("plugin\\acre2_win64.dll");
            if (path_x86 == "") {
                int result = MessageBoxA(NULL, "ACRE was unable to find x64 Teamspeak plugin file. The ACRE installation is corrupted. Please reinstall from Steam Workshop.", "ACRE Installation Error", MB_OK | MB_ICONERROR);
                //strncpy(output, "[-2]", outputSize);
                TerminateProcess(GetCurrentProcess(), 0);
                return;
            }
            std::vector<std::string> ts_locations;
            ts_locations.push_back(ReadRegValue(HKEY_LOCAL_MACHINE, "SOFTWARE\\TeamSpeak 3 Client", ""));
            ts_locations.push_back(ReadRegValue64(HKEY_LOCAL_MACHINE, "SOFTWARE\\TeamSpeak 3 Client", ""));
            ts_locations.push_back(ReadRegValue(HKEY_CURRENT_USER, "Software\\TeamSpeak 3 Client", ""));
            ts_locations.push_back(ReadRegValue64(HKEY_CURRENT_USER, "Software\\TeamSpeak 3 Client", ""));

            bool found = false;
            std::string found_paths = "";
            for (auto location : ts_locations) {
                if (location != "") {
                    found = true;
                    bool try_copy = true;
                    std::string ts_path_x86 = location + "\\plugins\\acre2_win32.dll";
                    std::string ts_path_x64 = location + "\\plugins\\acre2_win64.dll";
                    do {
                        if (!CopyFileA((LPCSTR)path_x86.c_str(), (LPCSTR)ts_path_x86.c_str(), false) || !CopyFileA((LPCSTR)path_x64.c_str(), (LPCSTR)ts_path_x64.c_str(), false)) {
                            DWORD last_error = GetLastError();
                            if (last_error == 32) {
                                int result = MessageBoxA(NULL, "ACRE was unable to copy the Teamspeak plugin due to it being in use. Please close any instances of Teamspeak 3 and click Retry.\n\nIf you would like to close Arma, click Abort. To ignore this error in the future and not attempt to copy this version of the Teamspeak plugin click Ignore.", "ACRE Installation Error", MB_ABORTRETRYIGNORE | MB_ICONEXCLAMATION);
                                if (result == IDABORT) {
                                    TerminateProcess(GetCurrentProcess(), 0);
                                    return;
                                }
                                else if (result == IDIGNORE) {
                                    write_config(current_version, 1);
                                    sprintf(output, "[-4,true,%d]", last_error);
                                    return;
                                }
                            } else { //Not error 32
                                int result = MessageBoxA(NULL, "ACRE was unable to copy the Teamspeak plugin. This is most likely because Steam is not running with admin privileges. Please restart Steam as administrator (right click on the shortcut -> run as administrator) and relaunch Arma 3 with ACRE2 loaded. You only need to do this when ACRE is updated. \n\nWould you like to run Arma 3 anyway?", "ACRE Installation Error", MB_YESNO | MB_ICONEXCLAMATION);
                                if (result == IDNO) {
                                    TerminateProcess(GetCurrentProcess(), 0);
                                    return;
                                } else {  //result is yes continue
                                    sprintf(output, "[-5,true,%d]", last_error);
                                    return;
                                }
                            }
                        }
                        else {
                            found_paths += location + "\n";
                            try_copy = false;
                        }
                    } while (try_copy);
                }
            }



            if (!found) {
                int result = MessageBoxA(NULL, "ACRE was unable to find a Teamspeak 3 installation. If you do have installation please copy the plugins yourself or reinstall Teamspeak.\n\nWould you like to ignore this error in the future (ignoring will prevent automatic installation for this version)?", "ACRE Installation Error", MB_YESNO | MB_ICONEXCLAMATION);
                if (result == IDYES) {
                    write_config(current_version, 1);
                    strncpy(output, "[-3,true]", outputSize);
                    return;
                }
                write_config(current_version, 0);
                strncpy(output, "[-3,false]", outputSize);
                return;
            }

            std::stringstream ss;
            ss << "A new version of ACRE2 (" << current_version << ") has been installed!\n";
            ss << "\n";
            ss << "The Teamspeak plugins have been copied to the following location(s):\n" << found_paths;
            ss << "\n";
            ss << "If this is NOT your Teamspeak installation folder(s), please uninstall all versions of Teamspeak and reinstall both it and ACRE2 or copy the plugins manually to your correct installation.\n";
            ss << "\n";
            ss << "If this appears to be the correct folder(s) please remember to enable the plugin in Teamspeak!";
            int result = MessageBoxA(NULL, (LPCSTR)ss.str().c_str(), "ACRE Installation Success", MB_OK | MB_ICONINFORMATION);
            write_config(current_version, 1);

            sprintf(output, "[1,\"%s\"]", found_paths.c_str());
            return;
        }
        default:
            return;
    }
}




void Init(void) {

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
