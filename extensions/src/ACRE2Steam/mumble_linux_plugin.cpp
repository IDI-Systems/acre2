#include "mumble_linux_plugin.hpp"
#include "wine.h"

#include <array>

using ::idi::acre::MumbleLinuxPlugin;

bool MumbleLinuxPlugin::collect_plugin_locations() noexcept {
    if (get_skip_plugin()) {
        return true;
    }

    if (!detectWine()) {
        return true;
    }

    // No 32-bit Linux plugin
    set_arch_to_install(Architecture::x64);

    if (!mumble_path.empty()) {
        check_plugin_locations(mumble_path);
    } else {
        std::string mumble_data_path("Mumble\\Mumble");
        std::string check_path;
        if (getenv("XDG_DATA_HOME")) {
            check_path = (std::filesystem::path("Z:") / getenv("XDG_DATA_HOME") / mumble_data_path).string();
        } else if (char* winehome = getenv("WINEHOMEDIR")) {
            if (strstr(winehome, "\\??\\")) {
                winehome = winehome + 4;
            }
            check_path = (std::filesystem::path(winehome) / ".local\\share" / mumble_data_path).string();
        } else {
            return false;
        }
        printf("%s\n", check_path.c_str());
        printf("%d\n", std::filesystem::exists(check_path));
        check_plugin_locations(check_path);
    }

    // No locations to copy to.
    return !get_plugin_locations().empty();
}
