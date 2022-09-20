/**
 * Mumble auto-plugin copy functionality for running under Wine.
 */
#pragma once
#include "voip_plugin.hpp"

#include <algorithm>
#include <sstream>

namespace idi::acre {
    class MumbleLinuxPlugin final : public VOIPPlugin {
    public:
        explicit MumbleLinuxPlugin(bool skip_plugin_, std::string mumble_path_ = "") noexcept
            : VOIPPlugin(skip_plugin_,
                "",
                "",
                find_mod_file("plugin\\mumble\\acre2_x64.so")),
              mumble_path(std::move(mumble_path_)) {}
        ~MumbleLinuxPlugin() noexcept final = default;

        bool collect_plugin_locations() noexcept final;

    private:
        std::string mumble_path;
    };
} // namespace idi::acre
