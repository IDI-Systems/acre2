#include "mumble_plugin.hpp"

#include <array>

using ::idi::acre::MumblePlugin;

bool MumblePlugin::collect_plugin_locations() noexcept {
    if (get_skip_plugin()) {
        return true;
    }

    if (!mumble_path.empty()) {
        check_plugin_locations(mumble_path);
    } else {
        parse_mumble_registry(false); // 32 bits
        parse_mumble_registry(true);  // 64 bits

        // TODO: 32 bits applications will not recognise FOLDERID_ProgramFilesX64
        std::array<KNOWNFOLDERID, 2> folder_ids = {FOLDERID_ProgramFilesX86, FOLDERID_ProgramFilesX64};
        for (const auto folder : folder_ids) {
            wchar_t *folder_path = nullptr;
            SHGetKnownFolderPath(folder, 0, nullptr, &folder_path);

            if (folder_path == nullptr) {
                return false;
            }

            // Convert to UTF-8 string
            std::string app_data = VOIPPlugin::wide_string_to_utf8(folder_path);

            app_data.append("\\Mumble");
            check_plugin_locations(app_data);

            // Now do the same for x64
            CoTaskMemFree(folder_path); // Free it up.
        }
    }

    // Do not delete if we need to copy it
    std::vector<std::string> mumble_locations        = get_plugin_locations();
    std::vector<std::string> mumble_delete_locations = get_plugin_delete_locations();

    for (const auto &location : mumble_locations) {
        mumble_delete_locations.erase(
          std::remove(mumble_delete_locations.begin(), mumble_delete_locations.end(), location), mumble_delete_locations.end());
    }

    // No locations to copy to.
    return !get_plugin_locations().empty();
}

void MumblePlugin::parse_mumble_registry(const bool use_x64_) noexcept {
    REGSAM sam_key = KEY_READ | KEY_WOW64_64KEY;

    if (!use_x64_) {
        sam_key = KEY_READ;
    }

    HKEY registry_key;
    if (RegOpenKeyEx(HKEY_CURRENT_USER, get_registry_key().c_str(), 0, sam_key, &registry_key) != ERROR_SUCCESS) {
        return;
    }

    DWORD num_subkeys = 0;
    if (RegQueryInfoKey(registry_key, nullptr, nullptr, nullptr, &num_subkeys, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr,
          nullptr) != ERROR_SUCCESS) {
        RegCloseKey(registry_key);
        return;
    }

    for (DWORD idx = 0; idx < num_subkeys; idx++) {
        TCHAR achKey[max_key_length];
        DWORD cbName = max_key_length;
        if (RegEnumKeyEx(registry_key, idx, achKey, &cbName, nullptr, nullptr, nullptr, nullptr) != ERROR_SUCCESS) {
            continue;
        }

        HKEY plugin_key;
        std::string name = get_registry_key() + "\\" + std::string(achKey);
        if (RegOpenKeyEx(HKEY_CURRENT_USER, name.c_str(), 0, KEY_READ | KEY_WOW64_64KEY, &plugin_key) != ERROR_SUCCESS) {
            continue;
        }

        DWORD type;
        DWORD cbData;
        if (RegQueryValueEx(plugin_key, "path", nullptr, &type, nullptr, &cbData) != ERROR_SUCCESS) {
            RegCloseKey(plugin_key);
            continue;
        }

        if (type != REG_SZ) {
            RegCloseKey(plugin_key);
            continue;
        }

        std::string file_path(cbData / sizeof(char), '\0');
        if (RegQueryValueEx(plugin_key, "path", nullptr, nullptr, reinterpret_cast<LPBYTE>(&file_path[0]), &cbData) == ERROR_SUCCESS) {
            RegCloseKey(plugin_key);

            size_t first_null = file_path.find_first_of('\0');
            if (first_null != std::string::npos) {
                file_path.resize(first_null);
            }

            std::filesystem::path plugin_path(file_path);
            if (std::filesystem::exists(plugin_path)) {
                const std::string mumble_path = plugin_path.parent_path().parent_path().string();
                check_plugin_locations(mumble_path);
            }
        }
    }

    RegCloseKey(registry_key);
}
