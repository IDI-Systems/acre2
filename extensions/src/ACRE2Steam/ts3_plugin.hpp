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
#include <sstream>

namespace idi::acre {
    class TS3Plugin final : public VOIPPlugin {
    public:
        explicit TS3Plugin(bool skip_plugin_) noexcept
            : VOIPPlugin(skip_plugin_,
                "SOFTWARE\\TeamSpeak 3 Client",
                find_mod_file("plugin/ts3/acre2_win32.dll"),
                find_mod_file("plugin/ts3/acre2_win64.dll")) {}
        ~TS3Plugin() noexcept final = default;

        bool collect_plugin_locations() noexcept final;
    };
} // namespace idi::acre
