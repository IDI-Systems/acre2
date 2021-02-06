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
#include <sstream>

namespace idi::acre {
    class MumblePlugin final : public VOIPPlugin {
    public:
        explicit MumblePlugin(bool skip_plugin_, std::string mumble_path_ = "") noexcept
            : VOIPPlugin(skip_plugin_,
                "SOFTWARE\\Mumble\\Mumble\\plugins",
                find_mod_file("plugin/mumble/acre2_win32.dll"),
                find_mod_file("plugin/mumble/acre2_win64.dll")),
              mumble_path(std::move(mumble_path_)) {}
        ~MumblePlugin() noexcept final = default;

        bool collect_plugin_locations() noexcept final;

    private:
        void parse_mumble_registry(const bool use_x64_) noexcept;

        static constexpr std::uint8_t max_key_length = 255U;
        std::string mumble_path;
    };
} // namespace idi::acre
