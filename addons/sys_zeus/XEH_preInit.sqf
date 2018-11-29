#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(keyDownWait) = false;

private _zeusCategory = format ["ACRE %1", localize "str_a3_cfghints_curator_curator_displayname"];

// Default remote controlled voice source
[
    QGVAR(zeusDefaultVoiceSource),
    "LIST",
    localize LSTRING(ZeusDefaultVoiceSource_displayName),
    _zeusCategory,
    [[false, true], ["str_a3_cfgvehicles_moduleremotecontrol_f", "STR_A3_Leaderboards_Header_Player"], 0]
] call CBA_Settings_fnc_init;

// Ability to hear through the Zeus camera
[
    QGVAR(zeusListenViaCamera),
    "CHECKBOX",
    localize LSTRING(ZeusListenViaCamera_displayName),
    _zeusCategory,
    true
] call CBA_Settings_fnc_init;

// Ability to join the spectator chat
[
    QGVAR(zeusCanSpectate),
    "CHECKBOX",
    localize LSTRING(ZeusCanSpectate_displayName),
    _zeusCategory,
    true
] call CBA_Settings_fnc_init;

ADDON = true;
