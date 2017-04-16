#include "shared.hpp"
#include "logging.hpp"
#include "dynloader.hpp"

INITIALIZE_EASYLOGGINGPP

BOOLEAN WINAPI DllMain(IN HINSTANCE hDllHandle,
    IN uint32_t     nReason,
    IN LPVOID    Reserved) {
    BOOLEAN bSuccess = true;
    el::Configurations conf;

    switch (nReason) {
    case DLL_PROCESS_ATTACH:
        conf.setGlobally(el::ConfigurationType::Filename, "logs/ace_dynload.log");
        el::Loggers::setDefaultConfigurations(conf, true);

        conf.set(
            el::Level::Global,
            el::ConfigurationType::Filename,
            "logs/server_events.log");

        // Register functions
        acre::dynloader::get().register_functions();

        break;
    case DLL_PROCESS_DETACH:
        break;
    }

    return bSuccess;

}