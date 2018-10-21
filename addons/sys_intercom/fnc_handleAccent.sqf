#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles setting up accent in the master station.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 2: Intercom network <NUMBER>
 * 3: Accent active <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(vehicle acre_player), "intercom1", true] call acre_sys_intercom_fnc_handleAccent
 *
 * Public: No
 */

params ["_vehicle", "_intercomNetwork", "_accentActive"];

private _accentConfig = _vehicle getVariable [QGVAR(accent), []];
private _changes = false;

{
    if (_intercomNetwork == _forEachIndex || {_intercomNetwork == ALL_INTERCOMS}) then {
        _accentConfig set [_forEachIndex, _accentActive];
        _changes = true;
    };
} forEach (_vehicle getVariable [QGVAR(intercomNames), []]);

// Only broadcast if changes have been made
if (_changes) then {
    _vehicle setVariable [QGVAR(accent), _accentConfig, true];
};
