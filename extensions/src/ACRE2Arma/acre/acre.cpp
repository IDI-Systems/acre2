/*
* ace_vd.cpp
*
*
*/

#include "Macros.h"
#include "shared.hpp"
#include "controller.hpp"
#include "arguments.hpp"
#include <atomic>

#ifndef _STATIC
extern "C" {
    __declspec (dllexport) void __stdcall RVExtensionVersion(char *output, int outputSize);
    __declspec (dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
    __declspec(dllexport) int __stdcall RVExtensionArgs(char* output, int outputSize, const char* function, const char** argv, int argc);
    __declspec (dllexport) void __stdcall RVExtensionRegisterCallback(int(*callbackProc)(char const* name, char const* function, char const* data));
};
#endif

std::function<int(char const*, char const*, char const*)> callbackFunc = [](char const*, char const*, char const*) {
    LOG(ERROR) << "RVExtensionRegisterCallback never called";
    return -2;
};
void __stdcall RVExtensionRegisterCallback(int(*callbackProc)(char const* name, char const* function, char const* data)) {
    LOG(INFO) << "RVExtensionRegisterCallback called";
    callbackFunc = callbackProc;
}

void __stdcall RVExtensionVersion(char *output, int outputSize) {
    sprintf_s(output, outputSize - 1, "%s", ACRE_VERSION);
}

std::string get_command(const std::string & input) {
    size_t cmd_end;
    std::string command;

    cmd_end = input.find(':');
    if (cmd_end < 1) {
        return "";
    }

    return input.substr(0, cmd_end);
}

std::atomic_bool _threaded = false;

void __stdcall RVExtension(char *output, int outputSize, const char *function) {
    ZERO_OUTPUT();

    // Get the command, then the command args
    std::string input = function;

    std::string command = get_command(input);
    std::string argument_str;
    if (command.length() > 1 && input.length() > command.length() + 1) {
        argument_str = input.substr(command.length() + 1, (input.length() + 1 - command.length()));
    }
    acre::arguments _args(argument_str);

    std::string result_string = "-1";
    std::int32_t result_dummy = 0;

    _threaded = false;
    if (command.size() < 1) {
        output[0] = 0x00;
        return;
    }
    if (command == "version") {
        result_string = ACRE_VERSION;
    }
    else if (command == "echo") {
        result_string = function;
    }
    else if (command == "async") {
        _threaded = true;
        result_string = "0";
    }
    else if (command == "stop") {
        _threaded = false;
    }
    else if (command == "process_signal") {
        _threaded = true;
    }
    else if (command == "load_map") {
        _threaded = true;
    }
    else if (command == "signal_map") {
        _threaded = true;
    }

    acre::controller::get().call(command, _args, result_string, result_dummy, _threaded);
    if (!result_string.empty()) {
        sprintf_s(output, outputSize, "%s", result_string.c_str());
    }
    EXTENSION_RETURN();
}

int __stdcall RVExtensionArgs(char* output, int outputSize, const char* function, const char** argv, int argc) {
    ZERO_OUTPUT();

    std::string command(function);
    acre::arguments _args(argv, argc);

    if (command != "process_signal") { EXTENSION_RETURN_VALUE(-3); } // only supported command for now

    std::string result_string;
    std::int32_t result_code = 0;

    acre::controller::get().call(command, _args, result_string, result_code, true);
    if (!result_string.empty()) {
        sprintf_s(output, outputSize, "%s", result_string.c_str());
    }
    EXTENSION_RETURN_VALUE(result_code);
}
