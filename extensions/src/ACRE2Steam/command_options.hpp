/**
 * @author    Ferran Obón Santacana (Magnetar) <ferran@idi-systems.com>
 *
 * @copyright Copyright (c) 2020 International Development & Integration Systems LLC
 *
 * Mumble auto-plugin copy functionality.
 */
#pragma once

#include <string>
#include <unordered_map>

namespace idi::acre {
    class Arguments {
    public:
        explicit Arguments(std::string& line_) noexcept(false) {
            parse_line(line_);
        }

        ~Arguments() = default;

        std::string get_argument(const std::string &key_) const noexcept;

        bool has_argument(const std::string& key_) const noexcept;

    private:
        void parse_line(const std::string& line_) noexcept(false);
        void handle_argument(const std::string& arg_) noexcept;

        std::unordered_map<std::string, std::string> arguments;
    };
}
