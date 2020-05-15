/**
 * @author    Ferran Obón Santacana (Magnetar) <ferran@idi-systems.com>
 * @author    Cliff Foster (Nou) <cliff@idi-systems.com>
 * @author    James Smith (Snippers) <james@idi-systems.com>
 *
 * @copyright Copyright (c) 2020 International Development & Integration Systems LLC
 *
 * TeamSpeak 3 auto-plugin copy functionality.
 */
#include "voip_plugin.hpp"

#include <algorithm>
#include <codecvt>
#include <sstream>


namespace idi::acre {
    class TS3Plugin final : public VOIPPlugin {
    public:
        explicit TS3Plugin(bool skip_plugin_) noexcept
            : VOIPPlugin(skip_plugin_, "SOFTWARE\\TeamSpeak 3 Client", find_mod_file("plugin/ts3/acre2_win32.dll"), find_mod_file("plugin/ts3/acre2_win64.dll")) {}
        ~TS3Plugin() noexcept final = default;

        bool collect_plugin_locations() noexcept final {
            if (get_skip_plugin()) {
                return true;
            }

            // Teamspeak 3 location - Default location - Roaming Appdata.
            wchar_t *app_data_roaming = nullptr;
            SHGetKnownFolderPath(FOLDERID_RoamingAppData, 0, nullptr, &app_data_roaming);

            if (app_data_roaming == nullptr) {
                return false;
            }

            // TODO: Substitude it with WideCharToMultiByte from "Windows.h"
            std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> conv;
            std::string app_data = conv.to_bytes(app_data_roaming);

            app_data.append("\\TS3Client");
            CoTaskMemFree(app_data_roaming); // Free it up.

            // 32 Bit - Machine
            std::string rootkey = read_reg_value(HKEY_LOCAL_MACHINE, get_registry_key().c_str(), "", false);
            check_plugin_locations(app_data, rootkey, HKEY_LOCAL_MACHINE);

            // 64 Bit - Machine
            rootkey = read_reg_value(HKEY_LOCAL_MACHINE, get_registry_key().c_str(), "", true);
            check_plugin_locations(app_data, rootkey, HKEY_LOCAL_MACHINE);

            // 32 Bit - User
            rootkey = read_reg_value(HKEY_CURRENT_USER, get_registry_key().c_str(), "", false);
            check_plugin_locations(app_data, rootkey, HKEY_CURRENT_USER);

            // 64 Bit - User
            rootkey = read_reg_value(HKEY_CURRENT_USER, get_registry_key().c_str(), "", true);
            check_plugin_locations(app_data, rootkey, HKEY_CURRENT_USER);

            // Do not delete if we need to copy it
            std::vector<std::string> ts3_locations        = get_plugin_locations();
            std::vector<std::string> ts3_delete_locations = get_plugin_delete_locations();

            for (const auto &location : ts3_locations) {
                (void) std::remove(ts3_delete_locations.begin(), ts3_delete_locations.end(), location);
            }

            // No locations to copy to.
            return !get_plugin_locations().empty();
        }
    };
} // namespace idi::acre
