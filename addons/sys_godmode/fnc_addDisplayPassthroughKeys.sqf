#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds God Mode key handling support to a custom display, which otherwise does not pass through CBA keybinds.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Successfully added passthrough key handling <BOOL>
 *
 * Example:
 * [display] call acre_sys_godmode_fnc_addDisplayPassthroughKeys
 *
 * Public: No
 */

params ["_display"];

_display displayAddEventHandler ["KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

    if (!GVAR(speaking)) then {
        private _category = format ["ACRE2 %1", localize LSTRING(godMode)];
        if ([_key, [_shift, _ctrl, _alt]] in (([_category, "GodModePTTKeyCurrentChannel"] call CBA_fnc_getKeybind) select 8)) then {
            [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPress)
        };
        if ([_key, [_shift, _ctrl, _alt]] in (([_category, "GodModePTTKeyGroup1"] call CBA_fnc_getKeybind) select 8)) then {
            [GODMODE_GROUP1] call FUNC(handlePttKeyPress)
        };
        if ([_key, [_shift, _ctrl, _alt]] in (([_category, "GodModePTTKeyGroup2"] call CBA_fnc_getKeybind) select 8)) then {
            [GODMODE_GROUP2] call FUNC(handlePttKeyPress)
        };
        if ([_key, [_shift, _ctrl, _alt]] in (([_category, "GodModePTTKeyGroup3"] call CBA_fnc_getKeybind) select 8)) then {
            [GODMODE_GROUP3] call FUNC(handlePttKeyPress)
        };
    };

    false
}];

_display displayAddEventHandler ["KeyUp", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

    private _category = format ["ACRE2 %1", localize LSTRING(godMode)];
    if ([_key, [_shift, _ctrl, _alt]] in (([_category, "GodModePTTKeyCurrentChannel"] call CBA_fnc_getKeybind) select 8)) then {
        [GODMODE_CURRENTCHANNEL] call FUNC(handlePttKeyPressUp)
    };
    if ([_key, [_shift, _ctrl, _alt]] in (([_category, "GodModePTTKeyGroup1"] call CBA_fnc_getKeybind) select 8)) then {
        [GODMODE_GROUP1] call FUNC(handlePttKeyPressUp)
    };
    if ([_key, [_shift, _ctrl, _alt]] in (([_category, "GodModePTTKeyGroup2"] call CBA_fnc_getKeybind) select 8)) then {
        [GODMODE_GROUP2] call FUNC(handlePttKeyPressUp)
    };
    if ([_key, [_shift, _ctrl, _alt]] in (([_category, "GodModePTTKeyGroup3"] call CBA_fnc_getKeybind) select 8)) then {
        [GODMODE_GROUP3] call FUNC(handlePttKeyPressUp)
    };

    false
}];

true
