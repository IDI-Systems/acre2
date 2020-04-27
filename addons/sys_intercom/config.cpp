#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_sys_core", "acre_sys_attenuate", "acre_sys_sounds", "acre_sys_gui"};
        author = ECSTRING(main,Author);
        authors[] = {"TheMagnetar", "Jonpas", "Snippers"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.hpp"
#include "CfgEventHandlers.hpp"

#include "DialogDefines.hpp"
#include "vic3_dialogClasses.hpp"
#include "vic3_intercomDialogs.hpp"
