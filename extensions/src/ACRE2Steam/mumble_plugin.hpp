/**
 * @author    Ferran Obón Santacana (Magnetar) <ferran@idi-systems.com>
 *
 * @copyright Copyright (c) 2020 International Development & Integration Systems LLC
 *
 * Mumble auto-plugin copy functionality.
 */
#pragma once
#include "voip_plugin.hpp"

#include <algorithm>
#include <array>
#include <codecvt>
#include <sstream>


namespace idi::acre {
    class Mumble_plugin final : public VOIPPlugin {
    public:
        explicit Mumble_plugin(bool skip_plugin_, std::string mumble_path_ = "") noexcept
            : VOIPPlugin(skip_plugin_, "SOFTWARE\\Mumble\\Mumble", find_mod_file("plugin/mumble/acre2_win32.dll"), find_mod_file("plugin/mumble/acre2_win64.dll")),
              mumble_path(std::move(mumble_path_)) {}
        ~Mumble_plugin() noexcept final = default;

        bool collect_plugin_locations() noexcept final {
            if (get_skip_plugin()) {
                return true;
            }

            if (!mumble_path.empty()) {
                check_plugin_locations(mumble_path);
            } else {
                std::array<KNOWNFOLDERID, 2> folder_ids = {FOLDERID_ProgramFilesX86, FOLDERID_ProgramFilesX64};
                for (const auto folder : folder_ids) {
                    wchar_t *app_data_roaming = nullptr;
                    SHGetKnownFolderPath(folder, 0, nullptr, &app_data_roaming);

                    if (app_data_roaming == nullptr) {
                        return false;
                    }

                    // TODO: Substitude it with WideCharToMultiByte from "Windows.h"
                    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> conv;
                    std::string app_data = conv.to_bytes(app_data_roaming);

                    app_data.append("\\Mumble");
                    check_plugin_locations(app_data);

                    // Now do the same for x64
                    CoTaskMemFree(app_data_roaming); // Free it up.
                }
            }

            // No locations to copy to.
            return !get_plugin_locations().empty();
        }

    private:
        std::string mumble_path;
    };
} // namespace idi::acre
