#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sends a text message to a specific group preset (only alive units).
 *
 * Arguments:
 * 0: Text message <STRING>
 * 1: Group index (0-based index) <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["text message", 0] call acre_sys_godmode_fnc_sendTextMessage
 *
 * Public: No
 */

params ["_text", "_group"];

if !([_group] call FUNC(accessAllowed)) exitWith { false };

private _targetUnits = GVAR(groupPresets) select _group;

// Dynamic targets
if (_targetUnits isEqualType {}) then {
    _targetUnits = call _targetUnits;
};

#ifndef ALLOW_EMPTY_TARGETS
if (GVAR(targetUnits) isEqualTo []) exitWith {
    [[ICON_RADIO_CALL], [localize LSTRING(noTargets)], true] call CBA_fnc_notify;
    false
};
#endif

// Translate UIDs to units
_targetUnits = _targetUnits apply {
    if (_x isEqualType "") then {
        [_x] call BIS_fnc_getUnitByUID
    } else {
        _x
    };
};

[QGVAR(showText), [profileName, _text], _targetUnits] call CBA_fnc_targetEvent;

true
