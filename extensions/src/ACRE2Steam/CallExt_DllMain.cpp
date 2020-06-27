/**
 * @author    Ferran Obón Santacana (Magnetar) <ferran@idi-systems.com>
 * @author    Cliff Foster (Nou) <cliff@idi-systems.com>
 * @author    James Smith (snippers) <james@idi-systems.com>
 *
 * @copyright Copyright (c) 2020 International Development & Integration Systems LLC
 *
 * Voice over IP auto-plugin copy functionality.
 */

#include "compat.h"
//#include "Log.h"
#include "Macros.h"
#include "Shlwapi.h"
#include "command_options.hpp"
#include "mumble_plugin.hpp"
#include "shlobj.h"
#include "ts3_plugin.hpp"

#include <algorithm>
#include <cctype>
#include <fstream>
#include <functional>
#include <future>
#include <iostream>
#include <locale>
#include <sstream>
#include <string>
#include <vector>

#pragma comment(lib, "shlwapi.lib")

enum class SteamCommand : uint8_t { check, get_path, do_copy };

void ClosePipe();

extern "C" {
__declspec(dllexport) void __stdcall RVExtensionVersion(char *output, int outputSize);
__declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
};

void __stdcall RVExtensionVersion(char *output, int outputSize) {
    sprintf_s(output, outputSize - 1, "%s", ACRE_VERSION);
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

    const auto command = static_cast<SteamCommand>(std::atoi(id.c_str()));

    std::string cmd_line = std::string(GetCommandLineA());
    idi::acre::Arguments cmd_args(cmd_line);
    if (cmd_args.has_argument("-skipAcrePluginCopy")) {
        return;
    }

    const bool skip_ts_plugin     = cmd_args.has_argument("-skipAcreTSPluginCopy");
    const bool skip_mumble_plugin = cmd_args.has_argument("-skipAcreMumblePluginCopy");

    std::string test = cmd_args.get_argument("-mumblePath");

    idi::acre::TS3Plugin ts3_plugin(skip_ts_plugin);
    idi::acre::MumblePlugin mumble_plugin(skip_mumble_plugin, cmd_args.get_argument("-mumblePath"));

    switch (command) {
        case SteamCommand::check: {
            strncpy(output, "1", outputSize);
            return;
        }
        case SteamCommand::get_path: {
            std::string path;
            if (skip_ts_plugin) {
                path = ts3_plugin.read_reg_value(HKEY_LOCAL_MACHINE, ts3_plugin.get_registry_key().c_str(), "", false);
            }

            if (skip_mumble_plugin) {
                path.append("\n" + mumble_plugin.read_reg_value(HKEY_LOCAL_MACHINE, mumble_plugin.get_registry_key().c_str(), "", false));
            }
            strncpy(output, path.c_str(), outputSize);
            return;
        }
        case SteamCommand::do_copy: {
            std::string current_version = params;

            // Check ACRE2 installation
            if (!ts3_plugin.check_acre_installation() || !mumble_plugin.check_acre_installation()) {
                std::vector<std::string> missing_plugins = ts3_plugin.get_missing_acre_plugins();
                missing_plugins.insert(missing_plugins.end(), std::begin(mumble_plugin.get_missing_acre_plugins()),
                  std::end(mumble_plugin.get_missing_acre_plugins()));

                std::ostringstream oss;
                oss << "ACRE2 was unable to find ACRE 2 plugin files.\n\n";
                for (const auto &missing : missing_plugins) {
                    oss << "\t" << missing << "\n";
                }
                oss << "\n\nThe ACRE2 installation is likely corrupted. Please reinstall.";

                const std::int32_t result =
                  MessageBoxA(nullptr, (LPCSTR) oss.str().c_str(), "ACRE2 Installation Error", MB_OK | MB_ICONERROR);
                TerminateProcess(GetCurrentProcess(), 0);
                return;
            }

            const bool ts3_locations_success    = ts3_plugin.collect_plugin_locations();
            const bool mumble_locations_success = mumble_plugin.collect_plugin_locations();

            if (!ts3_locations_success && !mumble_locations_success) {
                const std::int32_t result = MessageBoxA(nullptr,
                  "ACRE2 was unable to find a TeamSpeak 3 or a Mumble installation. If you do have an installation please copy the plugins "
                  "yourself or reinstall TeamSpeak 3.\n\nIf you are sure you have Mumble and/or TeamSpeak 3 installed and wish to "
                  "prevent this message from appearing again remove ACRE2Steam.dll and ACRE2Steam_x64.dll from your @acre2 "
                  "folder.\n\nContinue anyway?",
                  "ACRE2 Installation Error", MB_YESNO | MB_ICONEXCLAMATION);
                if (result == IDYES) {
                    strncpy(output, "[-3,true]", outputSize);
                    return;
                }

                TerminateProcess(GetCurrentProcess(), 0);
                return;
            }

            bool try_copy = false;

            do {
                std::future<idi::acre::UpdateCode> update_ts3 =
                  std::async(std::launch::async, [&]() { return ts3_plugin.handle_update_plugin(); });
                std::future<idi::acre::UpdateCode> update_mumble =
                  std::async(std::launch::async, [&]() { return mumble_plugin.handle_update_plugin(); });

                const idi::acre::UpdateCode ts3_update_result    = update_ts3.get();
                const idi::acre::UpdateCode mumble_update_result = update_mumble.get();

                std::string error_msg;
                const bool update_ts3_ok =
                  (ts3_update_result != idi::acre::UpdateCode::update_failed) && (ts3_update_result != idi::acre::UpdateCode::other);
                if (!update_ts3_ok) {
                    error_msg = ts3_plugin.get_last_error_message();
                }

                const bool update_mumble_ok =
                  (mumble_update_result != idi::acre::UpdateCode::update_failed) && (mumble_update_result != idi::acre::UpdateCode::other);
                if (!update_mumble_ok) {
                    error_msg = mumble_plugin.get_last_error_message();
                }

                if (!update_ts3_ok || !update_mumble_ok) {
                    std::ostringstream oss;
                    oss << "ACRE2 was unable to copy the Mumble/TeamSpeak 3 plugin. Please check if you have write access to the plugin "
                        << "folder, close any instances of Mumble and/or TeamSpeak 3 and/or Mumble and click \"Try Again\".\n\nIf you "
                        << "would like to close Arma 3 click Cancel. Press Continue to launch Arma 3 regardless.\n\n"
                        << error_msg;
                    const int32_t result = MessageBoxA(
                      nullptr, (LPCSTR) oss.str().c_str(), "ACRE2 Installation Error", MB_CANCELTRYCONTINUE | MB_ICONEXCLAMATION);
                    if (result == IDCANCEL) {
                        TerminateProcess(GetCurrentProcess(), 0);
                        return;
                    } else if (result == IDCONTINUE) {
                        sprintf(output, "[-4,true,%d %d]", ts3_plugin.get_last_error(), mumble_plugin.get_last_error());
                        return;
                    }
                } else {
                    try_copy = true;

                    // Update was not necessary.
                    if ((ts3_update_result == idi::acre::UpdateCode::update_not_necessary) &&
                        (mumble_update_result == idi::acre::UpdateCode::update_not_necessary)) { // No update was copied etc.
                        strncpy(output, "[0]", outputSize);
                        return;
                    }
                }
            } while (!try_copy);

            std::ostringstream oss;
            oss << "A new version of ACRE2 (" << current_version << ") has been installed!\n\n";

            std::string found_paths;
            if (!ts3_plugin.get_updated_paths().empty()) {
                oss << "The TeamSpeak 3 plugins have been copied to the following location(s):\n";
                for (const auto &path : ts3_plugin.get_updated_paths()) {
                    oss << path << "\n";
                    found_paths.append(path + "\n");
                }

                oss << "\n";
            }

            if (!mumble_plugin.get_updated_paths().empty()) {
                oss << "The Mumble plugins have been copied to the following location(s):\n";
                for (const auto &path : mumble_plugin.get_updated_paths()) {
                    oss << path << "\n";
                    found_paths.append(path + "\n");
                }

                oss << "\n";
            }

            if (!ts3_plugin.get_removed_paths().empty()) {
                oss << "The TeamSpeak 3 plugin has been removed from the following location(s):\n";
                for (const auto &path : ts3_plugin.get_removed_paths()) {
                    oss << path << "\n";
                }

                oss << "\n";
            }

            if (!mumble_plugin.get_removed_paths().empty()) {
                oss << "The Mumble plugin has been removed from the following location(s):\n";
                for (const auto &path : mumble_plugin.get_removed_paths()) {
                    oss << path << "\n";
                }

                oss << "\n";
            }

            oss << "If this is NOT valid, please uninstall all versions of Mumble and/or TeamSpeak 3 and reinstall both it and ACRE2 or "
                << "copy the plugins manually to your correct installation.\n\n"
                << "If this appears to be the correct folder(s) please remember to enable the plugin in Mumble and/or TeamSpeak 3!";
            const int32_t result =
              MessageBoxA(nullptr, (LPCSTR) oss.str().c_str(), "ACRE2 Installation Success", MB_OK | MB_ICONINFORMATION);

            sprintf(output, "[1,\"%s\"]", found_paths.c_str());
            return;
        }
        default:
            return;
    }
}

void Init() {}

void Cleanup() {}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    switch (ul_reason_for_call) {
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
