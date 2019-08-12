#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_core"};
        author = ECSTRING(main,Author);
        authors[] = {"Jaynus", "Nou"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class RscText;
class RscPicture;
class RscXSliderH;
class RscProgress;
class RscStructuredText;
class RscPictureKeepAspect;
class RscControlsGroupNoScrollbars;

#include "RscTitles.hpp"
#include "RscInGameUI.hpp"
#include "CfgUIGrids.hpp"
