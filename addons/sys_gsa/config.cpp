#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {"vhf30108Item", "vhf30108spike"};
        weapons[] = {"ACRE_VHF30108", "ACRE_VHF30108SPIKE", "ACRE_VHF30108MAST"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_core"};
        author = ECSTRING(main,Author);
        authors[] = {"TheMagnetar", "Raspu", "RanTa"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
