#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = { QGVAR(Module_BabelLanguages); };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_sys_core"};
        author = ECSTRING(main,Author);
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class CfgFactionClasses {
    class NO_CATEGORY;
    class ACRE_BABEL: NO_CATEGORY {
        displayName = "ACRE Babel";
    };
};

#include "RscAttributes.hpp"
#include "CfgVehicles.hpp"
