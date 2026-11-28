#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_radio", "acre_sys_data", "acre_sys_io"};
        author = ECSTRING(main,Author);
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

// Clients ask the server for their voice server join token. The server identifies the caller
// itself (remoteExecutedOwner).
class CfgRemoteExec {
    class Functions {
        class DFUNC(requestVoiceToken) {
            allowedTargets = 2;
        };
    };
};

