/**
 * @author    Ferran Obón Santacana (Magnetar) <ferran@idi-systems.com>
 * @author    Cliff Foster (Nou) <cliff@idi-systems.com>
 * @author    James Smith (Snippers) <james@idi-systems.com>
 *
 *
 * @copyright Copyright (c) 2020 International Development & Integration Systems LLC
 *
 * Voice over IP auto-plugin copy functionality.
 */
#pragma once

#include "Shlwapi.h"
#include "shlobj.h"

#include <filesystem>
#include <string>
#include <vector>

namespace idi::acre {

    EXTERN_C IMAGE_DOS_HEADER __ImageBase;

    std::string find_mod_folder();

    std::string find_mod_file(const std::string &filename);

    enum class UpdateCode : std::uint8_t { update_not_necessary, update_ok, update_failed, other };
    enum class Architecture : std::uint8_t { both, x32, x64 };

    class VOIPPlugin {
    public:
        explicit VOIPPlugin(bool skip_plugin_,
          std::string registry_key_,
          const std::string &x32_plugin_path_,
          const std::string &x64_plugin_path_) noexcept
            : skip_plugin(skip_plugin_), registry_key(std::move(registry_key_)), x32_acre_plugin(x32_plugin_path_),
              x64_acre_plugin(x64_plugin_path_) {}

        virtual ~VOIPPlugin() noexcept = default;

        bool check_acre_installation() noexcept;

        std::string get_registry_key() const noexcept { return registry_key; }

        const std::string &get_last_error_message() const noexcept { return last_error_msg; }
        std::int32_t get_last_error() const noexcept { return last_error.value(); }

        const std::vector<std::string> &get_missing_acre_plugins() const noexcept { return missing_acre_plugins; }

        virtual bool collect_plugin_locations() noexcept = 0;

        UpdateCode handle_update_plugin() noexcept;

        const std::vector<std::string> &get_updated_paths() const noexcept { return updated_paths; }
        const std::vector<std::string> &get_removed_paths() const noexcept { return removed_paths; }

        std::string read_reg_value(HKEY root_, const std::string &key_, const std::string &name_, bool use_x64_) noexcept;

        const Architecture &get_arch_to_install() const noexcept { return arch_to_install; }

    protected:
        // Convert a wide Unicode string to an UTF8 string

        /**
         * Convert a wide Unicode string to an UTF8 string .
         *
         * @param[in] wide_str_  Wide unicode string
         *
         * @return std::string   UTF-8 encoded string
         */
        static std::string wide_string_to_utf8(const std::wstring &wide_str_) {
            if (wide_str_.empty()) {
                return "";
            }

            const int32_t size_needed =
              WideCharToMultiByte(CP_UTF8, 0, &wide_str_[0], static_cast<int32_t>(wide_str_.size()), nullptr, 0, nullptr, nullptr);

            std::string utf8_str(size_needed, 0);
            WideCharToMultiByte(
              CP_UTF8, 0, &wide_str_[0], static_cast<int32_t>(wide_str_.size()), &utf8_str[0], size_needed, nullptr, nullptr);

            return utf8_str;
        }

        bool get_skip_plugin() const noexcept { return skip_plugin; }

        bool compare_file(const std::string &path_a_, const std::string &path_b_) noexcept;

        void check_plugin_locations(const std::string &app_data_) noexcept;
        void check_plugin_locations(const std::string &appData, const std::string &rootkey, const HKEY key) noexcept;

        std::vector<std::string> &get_plugin_locations() noexcept { return plugin_locations; }
        void set_plugin_locations(const std::vector<std::string> locations_) { plugin_locations = locations_; }

        std::vector<std::string> &get_plugin_delete_locations() noexcept { return plugin_delete_locations; }
        void set_plugin_delete_locations(const std::vector<std::string> locations_) { plugin_delete_locations = locations_; }

        void set_arch_to_install(Architecture arch_) { arch_to_install = arch_; }

    private:
        bool skip_plugin = false;
        std::string registry_key;
        std::string last_error_msg;
        std::error_code last_error;

        std::vector<std::string> plugin_locations;        // Locations to copy the VOIP dll to.
        std::vector<std::string> plugin_delete_locations; // Locations to remove the VOIP dll from.

        std::vector<std::string> updated_paths;
        std::vector<std::string> removed_paths;

        std::filesystem::path x32_acre_plugin;
        std::filesystem::path x64_acre_plugin;
        Architecture arch_to_install = Architecture::both;
        std::vector<std::string> missing_acre_plugins;
    };
} // namespace idi::acre
