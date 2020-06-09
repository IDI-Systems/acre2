/**
 * @author    Ferran Obón Santacana (Magnetar) <ferran@idi-systems.com>
 * @author    Thymo- <thymovanbeers@gmail.com>
 *
 * @copyright Copyright (c) 2020 International Development & Integration Systems LLC
 *
 * Command line options for ACRE2.
 */

#include "command_options.hpp"

#include <fstream>
#include <sstream>

using ::idi::acre::Arguments;

std::string Arguments::get_argument(const std::string &key_) const noexcept {
    const auto it = arguments.find(key_);

    if (it == arguments.cend()) {
        return "";
    }

    return it->second;
}

bool Arguments::has_argument(const std::string &key_) const noexcept {
    return arguments.cend() != arguments.find(key_);
}

void Arguments::parse_line(const std::string &line_) noexcept(false) {
    std::istringstream iss(line_);
    std::string arg;
    while (std::getline(iss, arg, ' ')) {
        const std::string par_opt("-par=");
        std::string par_path;
        if (arg.find("-par") != std::string::npos) {
            par_path = arg.substr(par_opt.length());

            std::ifstream par_file(par_path);

            // Append all options from the parameter file
            if (!par_file.is_open()) {
                throw std::runtime_error("Parameters file could not be opened!");
            }

            std::string par_line;
            std::getline(par_file, par_line);
            if (par_line == "class Arg") {
                par_file.close();
                throw std::runtime_error("Old file format detected");
            }

            par_file.seekg(0, std::ifstream::beg);

            while (std::getline(par_file, par_line)) {
                handle_argument(par_line);
            }

            par_file.close();
        } else {
            handle_argument(arg);
        }
    }
}

void Arguments::handle_argument(const std::string &arg_) noexcept {
    const auto &option_pos = arg_.find('=');
    if (option_pos != std::string::npos) {
        arguments[arg_.substr(0, option_pos)] = arg_.substr(option_pos + 1, arg_.length() - option_pos);
    } else {
        arguments[arg_] = "";
    }
}
