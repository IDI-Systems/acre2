#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds key handling compatibility to a custom display, which otherwise does not pass through CBA keybinds.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Successfully added passthrough key handling <BOOL>
 *
 * Example:
 * [display] call acre_sys_core_fnc_addDisplayPassthroughKeys
 *
 * Public: Yes
 */

params ["_display"];

if (isNull _display) exitWith {false};

// Toggle Headset
_display displayAddEventHandler ["KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "HeadSet"] call CBA_fnc_getKeybind) select 8)) then {
        [] call FUNC(toggleHeadset);
    };
    false
}];

true
