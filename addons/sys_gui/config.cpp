#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_sys_radio", "acre_sys_zeus"};
        author = ECSTRING(main,Author);
        authors[] = {"Jaynus", "Nou"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class RscText;
class RscProgress;
class RscStructuredText;
class RscPictureKeepAspect;
class RscControlsGroupNoScrollbars;
class RscStandardDisplay;

// The Players screen: marks players who muted their microphone. It has no onLoad of its own (CBA's
// display events don't reach it). Its list is only filled in a mission, where the function exists.
class RscDisplayMPPlayers: RscStandardDisplay {
    onLoad = "with missionNamespace do {if (!isNil 'acre_sys_gui_fnc_playersDisplayLoad') then {_this call acre_sys_gui_fnc_playersDisplayLoad}}";
};

#include "RscTitles.hpp"
#include "RscInGameUI.hpp"
#include "CfgUIGrids.hpp"
