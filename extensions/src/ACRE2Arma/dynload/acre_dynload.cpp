/*
 * ace_vd.cpp
 *
 *
 */

#include "Macros.h"
#include "shared.hpp"
#include "arguments.hpp"
#include "dispatch.hpp"

static char version[] = "1.0";

#ifndef _STATIC
extern "C" {
    __declspec (dllexport) void __stdcall RVExtensionVersion(char *output, int outputSize);
    __declspec (dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
    __declspec(dllexport) int __stdcall RVExtensionArgs(char* output, int outputSize, const char* function, const char** argv, int argc);
    __declspec (dllexport) void __stdcall RVExtensionRegisterCallback(int(*callbackProc)(char const* name, char const* function, char const* data));
};
#endif

int(*callbackPtr)(char const* name, char const* function, char const* data) = nullptr;

void __stdcall RVExtensionVersion(char *output, int outputSize) {
    sprintf_s(output, outputSize - 1, "%s", ACRE_VERSION);
}
void __stdcall RVExtensionRegisterCallback(int(*callbackPtr_)(char const* name, char const* function, char const* data)) {
    LOG(INFO) << "RVExtensionRegisterCallback called";
    callbackPtr = callbackPtr_;
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


void __stdcall RVExtension(char *output, int outputSize, const char *function) {
    ZERO_OUTPUT();

    // Get the command, then the command args
    std::string input = function;

    std::string command = get_command(input);
    std::string argument_str;
    if (command.length() > 1 && input.length() > command.length()+1) {
        argument_str = input.substr(command.length() + 1, (input.length() + 1 - command.length()));
    }
    acre::arguments _args(argument_str);

    std::string result = "";

    if (command.size() < 1) {
        output[0] = 0x00;
        EXTENSION_RETURN();
    }
    if (command == "version") {
        result = ACRE_VERSION;
    }
    if (command == "echo") {
        result = function;
    }

    //LOG(INFO) << "RVExtension [" << function << " - " << _args.to_string() << "]";

    /*************************/
    // Real functionality goes here
    int result_dummy = 0;
    acre::dispatch::get().call(command, _args, result, result_dummy);

 
    sprintf_s(output, outputSize, "%s", result.c_str());
    EXTENSION_RETURN();
}

int __stdcall RVExtensionArgs(char* output, int outputSize, const char* function, const char** argv, int argc) {
    ZERO_OUTPUT();

    std::string command(function);
    acre::arguments _args(argv, argc);

    std::string result_string = "-1a";
    int32_t result_code = -1;

    if (command == "echo") {
        result_string = _args.to_string();
        result_code = static_cast<int>(_args.size());
    }

    //LOG(INFO) << "RVExtensionArgs [" << function << " - " << _args.to_string() << "]";

    /*************************/
    // Real functionality goes here
    acre::dispatch::get().call(command, _args, result_string, result_code);

    sprintf_s(output, outputSize, "%s", result_string.c_str());
    EXTENSION_RETURN_VALUE(result_code);
}
