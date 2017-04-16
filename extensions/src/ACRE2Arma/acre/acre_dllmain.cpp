#include "shared.hpp"
#include "logging.hpp"
#include "signal.hpp"
#include "controller.hpp"
INITIALIZE_EASYLOGGINGPP

BOOLEAN WINAPI DllMain(IN HINSTANCE hDllHandle,
    IN uint32_t     nReason,
    IN LPVOID    Reserved) {
    BOOLEAN bSuccess = true;
    el::Configurations conf;

    switch (nReason) {
    case DLL_PROCESS_ATTACH:
        conf.setGlobally(el::ConfigurationType::Filename, "logs/acre_dll.log");
        conf.setGlobally(el::ConfigurationType::MaxLogFileSize, "1048576");
#ifdef _DEBUG
        el::Loggers::reconfigureAllLoggers(el::ConfigurationType::Format, "[%datetime] - %level - {%loc}t:%thread- %msg");
        conf.setGlobally(el::ConfigurationType::PerformanceTracking, "true");
#else
        el::Loggers::reconfigureAllLoggers(el::ConfigurationType::Format, "%datetime-{%level}- %msg");
#endif
        el::Loggers::setDefaultConfigurations(conf, true);

        LOG(INFO) << "ACRE Loaded";

        break;
    case DLL_PROCESS_DETACH:
        if (Reserved == NULL) {
            //acre::signal::controller::get().stop();
            LOG(INFO) << "ACRE unloaded and halted";
        }
        break;
    }

    return bSuccess;

}
