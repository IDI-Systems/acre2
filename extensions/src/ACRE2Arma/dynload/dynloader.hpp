#pragma once

#include "shared.hpp"
#include "dispatch.hpp"
#include "arguments.hpp"

typedef void (__stdcall *RVExtensionVersion)(char *output, int outputSize);
typedef void (__stdcall *RVExtension)(char *output, int outputSize, const char *function);
typedef int (__stdcall *RVExtensionArgs)(char *output, int outputSize, const char *function, const char** args, int argsCnt);
typedef void(__stdcall* RVExtensionRegisterCallback)(int(*callbackProc)(const char* name, const char* function, const char* data));

extern int(*callbackPtr)(char const* name, char const* function, char const* data);

namespace acre {

    class module {
    public:
        module() : handle(nullptr), func_rv(nullptr), func_rvArgs(nullptr), name("") {}
        module(const std::string & name_, HMODULE handle_, RVExtension func_rv_, RVExtensionArgs func_rvArgs_, const std::string & file_) : handle(handle_), func_rv(func_rv_), func_rvArgs(func_rvArgs_), name(name_), temp_filename(file_) {}

        std::string name;
        std::string temp_filename;
        HMODULE     handle;
        RVExtension func_rv;
        RVExtensionArgs func_rvArgs;
    };

    class dynloader : public singleton<dynloader> {
    public:
        dynloader() {}
        ~dynloader() {
            for (auto & kv : _modules) {
                arguments temp(kv.first);
                std::string result_temp;
                unload(temp, result_temp);
            }
        }

#ifdef _WINDOWS
        bool load(const arguments & args_, std::string & result) {
            HMODULE dllHandle;
            RVExtension func_rv;
            RVExtensionArgs func_rvArgs;
            RVExtensionRegisterCallback func_rvCallback;

            LOG(INFO) << "Load requested [" << args_.as_string(0) << "]";

            if (_modules.find(args_.as_string(0)) != _modules.end()) {
                LOG(INFO) << "Module already loaded [" << args_.as_string(0) << "]";
                return true;
            }

#ifdef _WINDOWS
            // Make a copy of the file to temp, and load it from there, referencing the current path name
            char tmpPath[MAX_PATH +1], buffer[MAX_PATH + 1];

            if (!GetTempPathA(MAX_PATH, tmpPath)) {
                LOG(ERROR) << "GetTempPath() failed, e=" << GetLastError();
                return false;
            }
            if (!GetTempFileNameA(tmpPath, "acre_dynload", false, buffer)) { // get a unique temp filename each time
                LOG(ERROR) << "GetTempFileName() failed, e=" << GetLastError();
                return false;
            }
            std::string temp_filename = buffer;
            if (!CopyFileA(args_.as_string(0).c_str(), temp_filename.c_str(), FALSE)) {
                DeleteFile(temp_filename.c_str());
                if (!CopyFileA(args_.as_string(0).c_str(), temp_filename.c_str(), FALSE)) {
                    LOG(ERROR) << "CopyFile() , e=" << GetLastError();
                    return false;
                }
            }
#else
            std::string temp_filename = args_.as_string(0);
#endif

            dllHandle = LoadLibrary(temp_filename.c_str());
            if (!dllHandle) {
                LOG(ERROR) << "LoadLibrary() failed, e=" << GetLastError() << " [" << args_.as_string(0) << "]";
                return false;
            }
#ifdef _WIN64
            func_rv = (RVExtension)GetProcAddress(dllHandle, "RVExtension");
#else
            func_rv = (RVExtension)GetProcAddress(dllHandle, "_RVExtension@12");
#endif
            if (!func_rv) {
                LOG(ERROR) << "GetProcAddress() failed for RVExtension, e=" << GetLastError() << " [" << args_.as_string(0) << "]";
                FreeLibrary(dllHandle);
                return false;
            }
#ifdef _WIN64
            func_rvArgs = (RVExtensionArgs)GetProcAddress(dllHandle, "RVExtensionArgs");
#else
            func_rv = (RVExtension)GetProcAddress(dllHandle, "_RVExtensionArgs@20");
#endif
            
            if (!func_rvArgs) {
                LOG(INFO) << "-Extension does not support RVExtensionArgs, e=" << GetLastError() << " [" << args_.as_string(0) << "]";
            } else {
                LOG(INFO) << "-Extension supports RVExtensionArgs";
            }
#ifdef _WIN64
            func_rvCallback = (RVExtensionRegisterCallback)GetProcAddress(dllHandle, "RVExtensionRegisterCallback");
#else
            func_rvCallback = (RVExtensionRegisterCallback)GetProcAddress(dllHandle, "_RVExtensionRegisterCallback@4");
#endif
            if (!func_rvCallback) {
                LOG(INFO) << "-Extension does not support RVExtensionRegisterCallback, e=" << GetLastError() << " [" << args_.as_string(0) << "]";
            } else {
                LOG(INFO) << "-Extension supports RVExtensionRegisterCallback";
                func_rvCallback(callbackPtr); // Call it now
            }

            LOG(INFO) << "Load completed [" << args_.as_string(0) << "]";

            _modules[args_.as_string(0)] = module(args_.as_string(0), dllHandle, func_rv, func_rvArgs, temp_filename);

            return false;
        }
        bool unload(const arguments & args_, std::string & result) {

            LOG(INFO) << "Unload requested [" << args_.as_string(0) << "]";

            if (_modules.find(args_.as_string(0)) == _modules.end()) {
                LOG(INFO) << "Unload failed, module not loaded [" << args_.as_string(0) << "]";
                return true;
            }

            if (!FreeLibrary(_modules[args_.as_string(0)].handle)) {
                LOG(INFO) << "FreeLibrary() failed during unload, e=" << GetLastError();
                return false;
            }
            //if (!DeleteFileA(_modules[args_.as_string(0)].temp_filename.c_str())) {
            //    LOG(INFO) << "DeleteFile() failed during unload, e=" << GetLastError();
            //    return false;
            //}

            _modules.erase(args_.as_string(0));

            LOG(INFO) << "Unload complete [" << args_.as_string(0) << "]";

            return true;
        }
#endif

        bool callRV(const arguments & args_, std::string & result_string) {
            if (_modules.find(args_.as_string(0)) == _modules.end()) {
                return false;
            }

            result_string.clear();
            result_string.resize(4096);

            std::string function_str;
            std::vector<std::string> temp = acre::split(args_.to_string(), ',');

            if (temp.size() < 3) {
                function_str = temp[1];
            } else {
                for (int x = 1; x < temp.size(); x++)
                    function_str = function_str + temp[x] + ",";
            }
            _modules[args_.as_string(0)].func_rv((char *)result_string.c_str(), 4096, (const char *)function_str.c_str());
#ifdef _DEBUG
            //if (args_.as_string(0) != "fetch_result" && args_.as_string(0) != "ready") {
            //    LOG(INFO) << "Called [" << args_.as_string(0) << "], with {" << function_str << "} result={" << result << "}";
            //}
#endif
            return true;
        }

        bool callRVArgs(const arguments & args_, std::string & result_string, int & result_code) {
            std::string extension_file = args_.as_string(0);
            if (_modules.find(extension_file) == _modules.end()) {
                LOG(WARNING) << "callRVArgs could not find module [" << extension_file << "]";
                return false;
            } else if (!_modules[extension_file].func_rvArgs) {
                LOG(ERROR) << "module [" << extension_file << "] does not support CallExtensionArgs";
                return false;
            }

            result_string.clear();
            result_string.resize(4096);

            std::string function = args_.as_string(1);
            std::vector<const char*> cstrings;
            for (int i = 2; i < args_.size(); i++) {
                cstrings.push_back(args_.as_string(i).c_str());
            }

            result_code = _modules[extension_file].func_rvArgs((char*)result_string.c_str(), 4096, function.c_str(), cstrings.data(), static_cast<int>(cstrings.size()));
#ifdef _DEBUG
            if (args_.as_string(0) != "ready") {
                LOG(INFO) << "CalledArg [" << args_.as_string(0) << "], with {" << function << "} result={" << result_string << ", " << result_code << "}";
            }
#endif
            return true;
        }

        bool list(const arguments & args_, std::string & result) {

            LOG(INFO) << "Listing loaded modules";
            std::string res;

            for (auto & kv : _modules) {
                res = res + kv.first + ", ";
                LOG(INFO) << "\t" << kv.first;
            }

            result = res;

            return false;
        }

        bool register_functions() {
            dispatch::get().add("list", std::bind(&acre::dynloader::list, this, std::placeholders::_1, std::placeholders::_2));
            dispatch::get().add("load", std::bind(&acre::dynloader::load, this, std::placeholders::_1, std::placeholders::_2));
            dispatch::get().add("unload", std::bind(&acre::dynloader::unload, this, std::placeholders::_1, std::placeholders::_2));
            dispatch::get().add("call", std::bind(&acre::dynloader::callRV, this, std::placeholders::_1, std::placeholders::_2));
            dispatch::get().add("calla", std::bind(&acre::dynloader::callRVArgs, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3));

            return true;
        }
    protected:
        std::unordered_map<std::string, module> _modules;
    };
};
