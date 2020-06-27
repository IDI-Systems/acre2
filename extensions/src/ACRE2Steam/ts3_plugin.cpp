/**
 * @author    Ferran Obón Santacana (Magnetar) <ferran@idi-systems.com>
 * @author    Cliff Foster (Nou) <cliff@idi-systems.com>
 * @author    James Smith (Snippers) <james@idi-systems.com>
 *
 * @copyright Copyright (c) 2020 International Development & Integration
 * Systems LLC
 *
 * TeamSpeak 3 auto-plugin copy functionality.
 */
#include "ts3_plugin.hpp"

#include <array>

using ::idi::acre::TS3Plugin;

bool TS3Plugin::collect_plugin_locations() noexcept {
    if (get_skip_plugin()) {
        return true;
    }

    // Teamspeak 3 location - Default location - Roaming Appdata.
    wchar_t *app_data_roaming = nullptr;
    SHGetKnownFolderPath(FOLDERID_RoamingAppData, 0, nullptr, &app_data_roaming);

    if (app_data_roaming == nullptr) {
        return false;
    }

    // Convert to UTF-8 string
    std::string app_data = VOIPPlugin::wide_string_to_utf8(app_data_roaming);

    app_data.append("\\TS3Client");
    CoTaskMemFree(app_data_roaming); // Free it up.

    const std::array<HKEY, 2> registry_keys = {HKEY_LOCAL_MACHINE, HKEY_CURRENT_USER};

    for (const auto &key : registry_keys) {
        // 32 bits
        std::string rootkey = read_reg_value(key, get_registry_key().c_str(), "", false);
        check_plugin_locations(app_data, rootkey, key);

        // 64 bits
        rootkey = read_reg_value(key, get_registry_key().c_str(), "", true);
        check_plugin_locations(app_data, rootkey, key);
    }

    // Do not delete if we need to copy it
    std::vector<std::string> ts3_locations        = get_plugin_locations();
    std::vector<std::string> ts3_delete_locations = get_plugin_delete_locations();

    for (const auto &location : ts3_locations) {
        ts3_delete_locations.erase(
          std::remove(ts3_delete_locations.begin(), ts3_delete_locations.end(), location), ts3_delete_locations.end());
    }

    // No locations to copy to.
    return !get_plugin_locations().empty();
}
