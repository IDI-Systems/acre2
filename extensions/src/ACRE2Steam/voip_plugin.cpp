/**
 * @author    Ferran Obón Santacana (Magnetar) <ferran@idi-systems.com>
 * @author    Cliff Foster (Nou) <cliff@idi-systems.com>
 * @author    James Smith (Snippers) <james@idi-systems.com>
 *
 * @copyright Copyright (c) 2020 International Development & Integration Systems LLC
 *
 * Voice over IP auto-plugin copy functionality.
 */

#include "voip_plugin.hpp"

#include <algorithm>
#include <array>
#include <fstream>
#include <utility>

using ::idi::acre::VOIPPlugin;

std::string idi::acre::find_mod_folder() {
    char module_path[MAX_PATH];
    GetModuleFileNameA((HINSTANCE) &__ImageBase, module_path, MAX_PATH);

    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];

    _splitpath(module_path, drive, dir, nullptr, nullptr);

    return (std::string(drive) + std::string(dir));
}

std::string idi::acre::find_mod_file(const std::string &filename) {
    std::string path = find_mod_folder() + filename;
    if (!std::filesystem::exists(path)) {
        // No mod path was set, it means they used the mod config. It *DOES* mean it relative to a folder in our path at least.
        // So, we just search all the local folders

        WIN32_FIND_DATAA data;
        std::string path("");
        HANDLE hFile = FindFirstFileA(path.c_str(), &data);

        if (hFile == INVALID_HANDLE_VALUE) {
            return "";
        }

        while ((FindNextFile(hFile, &data) != 0) || (GetLastError() != ERROR_NO_MORE_FILES)) {
            if (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
                const std::string fullpath = std::string(data.cFileName) + filename;
                if (std::filesystem::exists(fullpath)) {
                    path = fullpath;
                    break;
                }
            }
        }
    }
    return path;
}

std::string VOIPPlugin::read_reg_value(HKEY root_, const std::string &key_, const std::string &name_, const bool use_x64_) noexcept {
    REGSAM sam_key = KEY_READ | KEY_WOW64_64KEY;

    if (!use_x64_) {
        sam_key = KEY_READ;
    }

    HKEY hkey;
    if (RegOpenKeyExA(root_, key_.c_str(), 0, sam_key, &hkey) != ERROR_SUCCESS) {
        return "";
    }

    DWORD type;
    DWORD cbData;
    if (RegQueryValueExA(hkey, name_.c_str(), nullptr, &type, nullptr, &cbData) != ERROR_SUCCESS) {
        RegCloseKey(hkey);
        return "";
    }

    if (type != REG_SZ) {
        RegCloseKey(hkey);
        return "";
    }

    std::string value(cbData / sizeof(char), '\0');
    if (RegQueryValueExA(hkey, name_.c_str(), nullptr, nullptr, reinterpret_cast<LPBYTE>(&value[0]), &cbData) != ERROR_SUCCESS) {
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

bool VOIPPlugin::compare_file(const std::string &path_a_, const std::string &path_b_) noexcept {
    // Open both files ath the end to check their size
    std::ifstream fileA(path_a_, std::ifstream::ate | std::ifstream::binary);
    std::ifstream fileB(path_b_, std::ifstream::ate | std::ifstream::binary);

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

void VOIPPlugin::check_plugin_locations(const std::string &app_data_) noexcept {
    if (std::filesystem::exists(app_data_) &&
        (plugin_locations.cend() == std::find(plugin_locations.cbegin(), plugin_locations.cend(), app_data_))) {
        plugin_locations.emplace_back(app_data_);
    }
}

void VOIPPlugin::check_plugin_locations(const std::string &app_data_, const std::string &root_key_, const HKEY key_) noexcept {
    if (root_key_.empty()) {
        return;
    }

    const std::string config_location = read_reg_value(key_, registry_key, "ConfigLocation", true);
    if (config_location == "0") {
        if (plugin_locations.end() == std::find(plugin_locations.cbegin(), plugin_locations.cend(), app_data_)) {
            plugin_locations.push_back(app_data_);
        }

        if (plugin_delete_locations.end() == std::find(plugin_delete_locations.cbegin(), plugin_delete_locations.cend(), root_key_)) {
            plugin_delete_locations.push_back(root_key_);
        }
    } else {
        if (plugin_locations.end() == std::find(plugin_locations.cbegin(), plugin_locations.cend(), root_key_)) {
            plugin_locations.push_back(root_key_);
        }

        if (plugin_delete_locations.end() ==
            std::find(plugin_delete_locations.cbegin(), plugin_delete_locations.cend(), root_key_ + "/config")) {
            plugin_delete_locations.push_back(root_key_ + "/config");
        }
    }
}

bool VOIPPlugin::check_acre_installation() noexcept {
    const bool x32_plugin_exist = std::filesystem::exists(x32_acre_plugin);
    const bool x64_plugin_exist = std::filesystem::exists(x64_acre_plugin);
    const bool x32_install      = arch_to_install == Architecture::both || arch_to_install == Architecture::x32;
    const bool x64_install      = arch_to_install == Architecture::both || arch_to_install == Architecture::x64;

    if (!x32_plugin_exist && x32_install) {
        missing_acre_plugins.emplace_back(x32_acre_plugin.filename().string());
    }

    if (!x64_plugin_exist && x64_install) {
        missing_acre_plugins.emplace_back(x64_acre_plugin.filename().string());
    }

    return (x32_plugin_exist || !x32_install) && (x64_plugin_exist || !x64_install);
}

idi::acre::UpdateCode VOIPPlugin::handle_update_plugin() noexcept {
    if (skip_plugin) {
        return UpdateCode::update_not_necessary;
    }

    UpdateCode update_status = UpdateCode::update_not_necessary;

    // Clean the error messages in case of retrying.
    if (!last_error_msg.empty()) {
        last_error_msg.clear();
    }

    if (!updated_paths.empty()) {
        updated_paths.clear();
    }

    for (const auto &location : plugin_locations) {
        std::filesystem::path plugin_folder(location + "/plugins");

        std::error_code err_code;
        if (!std::filesystem::exists(plugin_folder) && !std::filesystem::create_directory(plugin_folder, err_code)) {
            last_error_msg.append(err_code.message());
            last_error = err_code;

            return UpdateCode::other;
        }

        std::vector<std::pair<std::filesystem::path, std::filesystem::path>> plugin_paths_array;
        if (arch_to_install == Architecture::both || arch_to_install == Architecture::x32) {
            plugin_paths_array.push_back(std::make_pair(plugin_folder / x32_acre_plugin.filename(), x32_acre_plugin));
        }
        if (arch_to_install == Architecture::both || arch_to_install == Architecture::x64) {
            plugin_paths_array.push_back(std::make_pair(plugin_folder / x64_acre_plugin.filename(), x64_acre_plugin));
        }

        for (const auto &path : plugin_paths_array) {
            if (!compare_file(path.first.string(), path.second.string())) {
                bool copy_ok =
                  std::filesystem::copy_file(path.second, path.first, std::filesystem::copy_options::overwrite_existing, err_code);
                if (!copy_ok) {
                    last_error_msg.append(err_code.message());
                    last_error = err_code;

                    return UpdateCode::update_failed;
                }

                if (updated_paths.cend() == std::find(updated_paths.cbegin(), updated_paths.cend(), location)) {
                    updated_paths.emplace_back(location);
                }
                update_status = UpdateCode::update_ok;
            }
        }
    }

    for (const auto &location : plugin_delete_locations) {
        std::filesystem::path plugin_folder(location + "plugins");

        if (!std::filesystem::exists(plugin_folder)) {
            continue;
        }

        std::array<std::filesystem::path, 2> plugin_paths_array = {plugin_folder / x32_acre_plugin.filename(), plugin_folder / x64_acre_plugin.filename()};

        for (const auto &path : plugin_paths_array) {
            std::error_code err_code;
            bool remove_ok = std::filesystem::remove(path, err_code);
            if (!remove_ok) {
                last_error_msg.append(err_code.message());
                last_error = err_code;

                return UpdateCode::update_failed;
            }

            if (removed_paths.cend() == std::find(removed_paths.cbegin(), removed_paths.cend(), location)) {
                removed_paths.emplace_back(location);
            }
            update_status = UpdateCode::update_ok;
        }
    }

    return update_status;
}
