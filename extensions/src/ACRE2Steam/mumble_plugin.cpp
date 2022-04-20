#include "mumble_plugin.hpp"

#include <array>

using ::idi::acre::MumblePlugin;

bool MumblePlugin::collect_plugin_locations() noexcept {
    if (get_skip_plugin()) {
        return true;
    }

    if (!mumble_path.empty()) {
        // Install both plugins if a path is given, as there is no official portable Mumble
        // and a warning in chat window is fine for development purposes
        check_plugin_locations(mumble_path);
    } else {
        // Mumble location - Default location - Roaming Appdata.
        wchar_t *app_data_roaming = nullptr;
        SHGetKnownFolderPath(FOLDERID_RoamingAppData, 0, nullptr, &app_data_roaming);

        if (app_data_roaming == nullptr) {
            return false;
        }

        // Convert to UTF-8 string
        std::string app_data = VOIPPlugin::wide_string_to_utf8(app_data_roaming);
        CoTaskMemFree(app_data_roaming); // Free it up.

        // Path to install into (AppData/Roaming)
        app_data.append("\\Mumble");

        // Pick which architecture of the plugin to install to avoid Mumble showing warnings in the chat window
        bool x32_installed                      = false;
        bool x64_installed                      = false;
        std::array<KNOWNFOLDERID, 2> folder_ids = {FOLDERID_ProgramFilesX86, FOLDERID_ProgramFilesX64};
        for (const auto &folder : folder_ids) {
            std::string program_data;

            wchar_t *folder_path = nullptr;
            SHGetKnownFolderPath(folder, 0, nullptr, &folder_path);
            if (folder_path == nullptr) {
#ifdef _WIN64
                continue;
#else
                // FOLDERID_ProgramFilesX64 (or use of it in SHGetKnownFolderPath) is not supported in a 32-bit application,
                // but we may want to install x64 Mumble plugin while running x32 Arma,
                // fall back to registry read of x64 Program Files location
                program_data = read_reg_value(HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion", "ProgramFilesDir", true);
                if (program_data.empty()) {
                    continue;
                }
#endif
            } else {
                // Convert to UTF-8 string
                program_data = VOIPPlugin::wide_string_to_utf8(folder_path);
            }
            CoTaskMemFree(folder_path); // Free it up.

            program_data.append("\\Mumble");

            if (std::filesystem::exists(program_data)) {
                if (folder == folder_ids[0]) {
                    x32_installed = true;
                } else if (folder == folder_ids[1]) {
                    x64_installed = true;
                }
            }
        }

        // Mumble is not installed at all, don't copy plugins
        if (!x32_installed && !x64_installed) {
            return false;
        }

        // Otherwise copy to AppData and set the found architecture
        check_plugin_locations(app_data);

        if (x32_installed && !x64_installed) {
            set_arch_to_install(Architecture::x32);
        } else if (!x32_installed && x64_installed) {
            set_arch_to_install(Architecture::x64);
        }
    }

    // No locations to copy to.
    return !get_plugin_locations().empty();
}
