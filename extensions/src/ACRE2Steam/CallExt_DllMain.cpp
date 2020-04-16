#include "compat.h"
//#include "Log.h"
#include "Macros.h"
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

#pragma comment(lib, "shlwapi.lib")

enum class SteamCommand : uint8_t  {
    Check,
    GetPath,
    DoCopy
};

void ClosePipe();

extern "C" {
    __declspec (dllexport) void __stdcall RVExtensionVersion(char *output, int outputSize);
    __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
};

void __stdcall RVExtensionVersion(char *output, int outputSize) {
    sprintf_s(output, outputSize - 1, "%s", ACRE_VERSION);
}

inline std::string get_path() {
    char moduleName[MAX_PATH];
    GetModuleFileNameA(nullptr, moduleName, MAX_PATH);
    return std::string(moduleName);
}

inline std::string get_cmdline() {
    return std::string(GetCommandLineA());
}

inline std::string get_path(const std::string &filepath) {
    char drive[_MAX_DRIVE];
    char dir [_MAX_DIR];

    _splitpath(
        filepath.c_str(),
        drive,
        dir,
        nullptr,
        nullptr
        );

    return (std::string(drive) + std::string(dir));
}

inline std::string get_quoted(std::string &text) {
    std::string found_text = "";

    std::string::size_type start_position = text.find("\"");
    if (start_position != std::string::npos) {
        ++start_position; // start after the double quotes.
                          // look for end position;
        std::string::size_type end_position = text.find("\"");
        if (end_position != std::string::npos) {
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

    return (std::string(drive) + std::string(dir));
}

inline std::string find_mod_file(const std::string &filename) {
    std::string path = find_mod_folder() + filename;
    if (!PathFileExistsA(path.c_str())) {
        // No mod path was set, it means they used the mod config. It *DOES* mean it relative to a folder in our path at least.
        // So, we just search all the local folders

        WIN32_FIND_DATAA data;
        std::string path("");
        HANDLE hFile = FindFirstFileA(path.c_str(), &data);

        if (hFile == INVALID_HANDLE_VALUE)
            return "";

        while ((FindNextFile(hFile, &data) != 0) || (GetLastError() != ERROR_NO_MORE_FILES)) {
            if (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
                const std::string fullpath = std::string(data.cFileName) + filename;
                if (PathFileExistsA(fullpath.c_str())) {
                    path = fullpath;
                    break;
                }
            }
        }
    }
    return path;
}

std::string ReadRegValue(HKEY root, const std::string &key, const std::string &name) {
    HKEY hkey;
    if (RegOpenKeyExA(root, key.c_str(), 0, KEY_READ, &hkey) != ERROR_SUCCESS) {
        return "";
    }

    DWORD type;
    DWORD cbData;
    if (RegQueryValueExA(hkey, name.c_str(), nullptr, &type, nullptr, &cbData) != ERROR_SUCCESS) {
        RegCloseKey(hkey);
        return "";
    }

    if (type != REG_SZ) {
        RegCloseKey(hkey);
        return "";
    }

    std::string value(cbData / sizeof(char), '\0');
    if (RegQueryValueExA(hkey, name.c_str(), nullptr, nullptr, reinterpret_cast<LPBYTE>(&value[0]), &cbData) != ERROR_SUCCESS) {
        RegCloseKey(hkey);
        return "";
    }

    RegCloseKey(hkey);

    size_t firstNull = value.find_first_of('\0');
    if (firstNull != std::string::npos) {
        value.resize(firstNull);
    }

    return value;
}

std::string ReadRegValue64(HKEY root, const std::string &key, const std::string &name) {
    HKEY hkey;
    if (RegOpenKeyExA(root, key.c_str(), 0, KEY_READ | KEY_WOW64_64KEY, &hkey) != ERROR_SUCCESS)
        return "";

    DWORD type;
    DWORD cbData;
    if (RegQueryValueExA(hkey, name.c_str(), nullptr, &type, nullptr, &cbData) != ERROR_SUCCESS) {
        RegCloseKey(hkey);
        return "";
    }

    if (type != REG_SZ) {
        RegCloseKey(hkey);
        return "";
    }

    std::string value(cbData / sizeof(char), '\0');
    if (RegQueryValueExA(hkey, name.c_str(), nullptr, nullptr, reinterpret_cast<LPBYTE>(&value[0]), &cbData) != ERROR_SUCCESS) {
        RegCloseKey(hkey);
        return "";
    }

    RegCloseKey(hkey);

    size_t firstNull = value.find_first_of('\0');
    if (firstNull != std::string::npos)
        value.resize(firstNull);

    return value;
}

bool compare_file(const std::string &pathA, const std::string &pathB) {

    // Open both files ath the end to check their size
    std::ifstream fileA(pathA, std::ifstream::ate | std::ifstream::binary);
    std::ifstream fileB(pathB, std::ifstream::ate | std::ifstream::binary);

    if (fileA.tellg() != fileB.tellg()) {
        return false;
    }

    // Files are of the same size. Rewind and compare file contents
    fileA.seekg(0);
    fileB.seekg(0);

    std::istreambuf_iterator<char> beginA(fileA);
    std::istreambuf_iterator<char> beginB(fileB);

    return std::equal(beginA, std::istreambuf_iterator<char>(), beginB);
}

bool skip_plugin_copy() {
    if (std::string::npos != get_cmdline().find("-skipAcrePluginCopy")) {
        return true;
    }
    return false;
}

void checkTsLocations(const std::string &appData, const std::string &rootkey, const HKEY key, std::vector<std::string> &tsLocations, std::vector<std::string> &tsDeleteLocations) {
    if (rootkey != "") {
        const std::string configLocation = ReadRegValue64(key, "SOFTWARE\\TeamSpeak 3 Client", "ConfigLocation");
        if (configLocation == "0") {
            tsLocations.push_back(appData);
            tsDeleteLocations.push_back(rootkey);
        } else {
            tsLocations.push_back(rootkey);
            tsDeleteLocations.push_back(rootkey + "\\config");
        }
    }
}

void __stdcall RVExtension(char *output, int outputSize, const char *function) {
    size_t id_length = 1;
    std::string functionStr(function);

    if (functionStr.length() > 1) {
        if (isdigit(functionStr.substr(1, 1).c_str()[0])) {
            id_length = 2;
        }
    }

    const std::string id = functionStr.substr(0, id_length);
    std::string params;
    if (functionStr.length() > 1) {
        params = functionStr.substr(id_length, functionStr.length() - id_length);
    }

    const SteamCommand command = static_cast<SteamCommand>(std::atoi(id.c_str()));

    if (skip_plugin_copy()) {
        return;
    }

    switch(command) {
        case SteamCommand::Check: {
            strncpy(output, "1", outputSize);
            return;
        }
        case SteamCommand::GetPath: {
            std::string path = find_mod_file("ACRE2Steam.dll");
            path = ReadRegValue(HKEY_LOCAL_MACHINE, "SOFTWARE\\TeamSpeak 3 Client", "");
            strncpy(output, path.c_str(), outputSize);
            return;
        }
        case SteamCommand::DoCopy: {
            std::string current_version = params;

            const std::string path_x86 = find_mod_file("plugin\\acre2_win32.dll");
            const std::string path_x64 = find_mod_file("plugin\\acre2_win64.dll");
            if ((path_x86 == "") || (path_x64 == "")) {
                const std::string message_string = "ACRE2 was unable to find TeamSpeak 3 plugin file.\n\nMissing file: " + find_mod_folder() + "plugin\\acre2_win32.dll\n\nThe ACRE2 installation is likely corrupted. Please reinstall.";
                const int32_t result = MessageBoxA(nullptr, (LPCSTR) message_string.c_str(), "ACRE2 Installation Error", MB_OK | MB_ICONERROR);
                //strncpy(output, "[-1]", outputSize);
                TerminateProcess(GetCurrentProcess(), 0);
                return;
            }

            std::vector<std::string> ts_locations;        // Locations to copy the TS dll to.
            std::vector<std::string> ts_delete_locations; // Locations to remove the TS dll from.

            // Teamspeak 3.1 location - Default location - Roaming Appdata.
            wchar_t *appDataRoaming = nullptr;
            SHGetKnownFolderPath(FOLDERID_RoamingAppData, 0, nullptr, &appDataRoaming);

            std::wstringstream ssAppData;
            ssAppData << appDataRoaming;
            const std::wstring ws = ssAppData.str();
            std::string appData(ws.begin(), ws.end());
            appData += "\\TS3Client";
            CoTaskMemFree(appDataRoaming); //Free it up.

            /* 32 Bit - Machine */
            std::string rootkey = ReadRegValue(HKEY_LOCAL_MACHINE, "SOFTWARE\\TeamSpeak 3 Client", "");
            checkTsLocations(appData, rootkey, HKEY_LOCAL_MACHINE, ts_locations, ts_delete_locations);

            /* 64 Bit - Machine */
            rootkey = ReadRegValue64(HKEY_LOCAL_MACHINE, "SOFTWARE\\TeamSpeak 3 Client", "");
            checkTsLocations(appData, rootkey, HKEY_LOCAL_MACHINE, ts_locations, ts_delete_locations);

            /* 32 Bit - User */
            rootkey = ReadRegValue(HKEY_CURRENT_USER, "Software\\TeamSpeak 3 Client", "");
            checkTsLocations(appData, rootkey, HKEY_CURRENT_USER, ts_locations, ts_delete_locations);

            /* 64 Bit - User */
            rootkey = ReadRegValue64(HKEY_CURRENT_USER, "Software\\TeamSpeak 3 Client", "");
            checkTsLocations(appData, rootkey, HKEY_CURRENT_USER, ts_locations, ts_delete_locations);

            // Remove duplicates
            std::vector<std::string> unique_ts_locations;
            std::vector<std::string> unique_delete_ts_locations;
            for (auto location : ts_delete_locations) {
                if (location != "") {
                    bool found = false;
                    for (auto unique_ts : unique_delete_ts_locations) {
                        if (location == unique_ts) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        unique_delete_ts_locations.push_back(location);
                    }
                }
            }

            for (auto location : ts_locations) {
                if (location != "") {
                    bool found = false;
                    for (auto unique_ts : unique_ts_locations) {
                        if (location == unique_ts) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        unique_ts_locations.push_back(location);

                        // If we are going to copy to a folder do not remove from the plugin from it.
                        std::remove(unique_delete_ts_locations.begin(), unique_delete_ts_locations.end(), location);
                    }
                }
            }

            // No locations to copy to.
            if (unique_ts_locations.size() == 0) {
                const int32_t result = MessageBoxA(nullptr, "ACRE2 was unable to find a TeamSpeak 3 installation. If you do have an installation please copy the plugins yourself or reinstall TeamSpeak 3. \n\n If you are sure you have TeamSpeak 3 installed and wish to prevent this message from appearing again remove ACRE2Steam.dll and ACRE2Steam_x64.dll from your @acre2 folder.\n\nContinue anyway?", "ACRE2 Installation Error", MB_YESNO | MB_ICONEXCLAMATION);
                if (result == IDYES) {
                    strncpy(output, "[-3,true]", outputSize);
                    return;
                } else {
                    TerminateProcess(GetCurrentProcess(), 0);
                    return;
                }
            }

            bool updateRequired = false;
            std::string found_paths = "";
            for (auto location : unique_ts_locations) {
                bool try_copy = true;

                // Skip directory if the folder the plugins folder should be in does not exist.
                DWORD location_folder_attr = GetFileAttributes(location.c_str());
                if (location_folder_attr == INVALID_FILE_ATTRIBUTES) { continue; }
                if (!(location_folder_attr & FILE_ATTRIBUTE_DIRECTORY)) { continue; }

                const std::string plugin_folder = location + "\\plugins";

                // If plugins folder does not exist - create it
                CreateDirectory(plugin_folder.c_str(), nullptr); // This will silently fail if it exists - Exactly what we want.

                const std::string ts_path_x86 = plugin_folder + "\\acre2_win32.dll";
                const std::string ts_path_x64 = plugin_folder + "\\acre2_win64.dll";
                if (!compare_file(ts_path_x86, path_x86) || !compare_file(ts_path_x64, path_x64)) { // Only copy if files don't match.
                    updateRequired = true;
                    do {
                        if (!CopyFileA((LPCSTR)path_x86.c_str(), (LPCSTR)ts_path_x86.c_str(), false) || !CopyFileA((LPCSTR)path_x64.c_str(), (LPCSTR)ts_path_x64.c_str(), false)) {
                            DWORD last_error = GetLastError();
                            if (last_error == 32) {
                                const int32_t result = MessageBoxA(nullptr, "ACRE2 was unable to copy the TeamSpeak 3 plugin due to it being in use. Please close any instances of TeamSpeak 3 and click \"Try Again\".\n\nIf you would like to close Arma 3, click Cancel. Press Continue to launch Arma 3 regardless.", "ACRE2 Installation Error", MB_CANCELTRYCONTINUE | MB_ICONEXCLAMATION);
                                if (result == IDCANCEL) {
                                    TerminateProcess(GetCurrentProcess(), 0);
                                    return;
                                } else if (result == IDCONTINUE) {
                                    sprintf(output, "[-4,true,%d]", last_error);
                                    return;
                                }
                            } else { // Not error 32
                                const int32_t result = MessageBoxA(nullptr, "ACRE2 was unable to copy the TeamSpeak 3 plugin. This is most likely because Steam is not running with admin privileges. Please restart Steam as administrator (right click on the shortcut -> run as administrator) and relaunch Arma 3 with ACRE2 loaded. You only need to do this when ACRE2 is updated. \n\nWould you like to run Arma 3 anyway?", "ACRE2 Installation Error", MB_YESNO | MB_ICONEXCLAMATION);
                                if (result == IDNO) {
                                    TerminateProcess(GetCurrentProcess(), 0);
                                    return;
                                } else {  // Result is yes continue
                                    sprintf(output, "[-5,true,%d]", last_error);
                                    return;
                                }
                            }
                        } else {
                            found_paths += location + "\n";
                            try_copy = false;
                        }
                    } while (try_copy);
                }
            }

            std::string remove_paths = "";
            for (auto location : unique_delete_ts_locations) {
                const std::string plugin_folder = location + "\\plugins";

                // Skip directory if the plugins folder does not exist.
                DWORD plugin_folder_attr = GetFileAttributes(plugin_folder.c_str());
                if (plugin_folder_attr == INVALID_FILE_ATTRIBUTES) { continue; }
                if (!(plugin_folder_attr & FILE_ATTRIBUTE_DIRECTORY)) { continue; }

                std::vector<std::string> files;
                const std::string ts_path_x64 = plugin_folder + "\\acre2_win64.dll";
                files.push_back(ts_path_x64);
                const std::string ts_path_x86 = plugin_folder + "\\acre2_win32.dll";
                files.push_back(ts_path_x86);

                bool popupLocationNotify = false;
                for (auto file : files) {
                    bool try_delete = true;
                    {
                        if (!DeleteFileA(file.c_str())) {
                            DWORD last_error = GetLastError();
                            if (last_error != ERROR_FILE_NOT_FOUND) {
                                updateRequired = true;
                                if (last_error == FILE_SHARE_DELETE) { // File in use
                                    const int32_t result = MessageBoxA(nullptr, "ACRE2 is unable to copy the TeamSpeak 3 plugin due to it being in use. Please close any instances of TeamSpeak 3 and click \"Try Again\".\n\nIf you would like to close Arma 3, click Cancel. Press Continue to launch Arma 3 regardless.", "ACRE2 Installation Error", MB_CANCELTRYCONTINUE | MB_ICONEXCLAMATION);
                                    if (result == IDCANCEL) {
                                        TerminateProcess(GetCurrentProcess(), 0);
                                        return;
                                    } else if (result == IDCONTINUE) {
                                        sprintf(output, "[-4,true,%d]", last_error);
                                        return;
                                    }
                                } else {
                                    // ERROR_ACCESS_DENIED.
                                    const std::string message = "ACRE2 was unable to remove an old version of the TeamSpeak 3 plugin. You have two options:\n\n1) Manually delete the following file: \n" + file + "\n\n2) Restart Steam and Arma 3 as administrator (right click on the shortcut -> run as administrator) and relaunch Arma 3 with ACRE2 loaded. \n\nWould you like to run Arma 3 anyway?";
                                    const int32_t result = MessageBoxA(nullptr, (LPCSTR)message.c_str(), "ACRE2 Installation Error", MB_YESNO | MB_ICONEXCLAMATION);
                                    if (result == IDNO) {
                                        TerminateProcess(GetCurrentProcess(), 0);
                                        return;
                                    } else {  //result is yes continue
                                        sprintf(output, "[-5,true,%d]", last_error);
                                        return;
                                    }
                                }
                            } else {
                                // The dll was already removed, exit the loop.
                                try_delete = false;
                            }
                        } else {
                            // Successfully deleted the dll.
                            updateRequired = true;
                            try_delete = false;
                            if (!popupLocationNotify) {
                                // Prevent the location from being outputted to the pop-up twice.
                                remove_paths += location + "\n";
                                popupLocationNotify = true;
                            }
                        }
                    } while (try_delete);
                }
            }


            if (!updateRequired) { // No update was copied etc.
                strncpy(output, "[0]", outputSize);
                return;
            }

            std::stringstream ss;
            ss << "A new version of ACRE2 (" << current_version << ") has been installed!\n";
            ss << "\n";
            if (found_paths != "") {
                ss << "The TeamSpeak 3 plugins have been copied to the following location(s):\n" << found_paths;
                ss << "\n";
            }
            if (remove_paths != "") {
                ss << "The TeamSpeak 3 plugin has been removed from the following location(s):\n" << remove_paths << "\n";
                if (found_paths == "") {
                    ss << "An update to version is already in:\n" << unique_ts_locations.at(0) << "\n";
                    ss << "\n";
                }
            }
            ss << "If this is NOT valid, please uninstall all versions of TeamSpeak 3 and reinstall both it and ACRE2 or copy the plugins manually to your correct installation.\n";
            ss << "\n";
            ss << "If this appears to be the correct folder(s) please remember to enable the plugin in TeamSpeak 3!";
            const int32_t result = MessageBoxA(nullptr, (LPCSTR)ss.str().c_str(), "ACRE2 Installation Success", MB_OK | MB_ICONINFORMATION);

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
