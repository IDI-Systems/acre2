/*
 * Author: ACRE2Team
 * Disconnects the ground spike antenna and re-connects the default radio antenna.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unique Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "acre_prc152_id_1"] call acre_sys_gsa_fnc_connect
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_gsa", "_radioId"];

private _parentComponentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_radioId);

private _success = false;
{
    _x params ["_connector", "_component"];
    systemChat format ["_radioId %1 component %2", _radioId, _component];
    private _componentClass = configFile >> "CfgAcreComponents" >> _component;
    _success = [_radioId, 0, _componentClass, [], true] call EFUNC(sys_components,attachSimpleComponent);
    if (_success) exitWith {};
} forEach (getArray (_parentComponentClass >> "defaultComponents"));

_success
