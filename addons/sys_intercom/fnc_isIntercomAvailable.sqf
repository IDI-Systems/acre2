/*
 * Author: ACRE2Team
 * Checks if an intercom network station is available for a given position.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * True if intercom network is available, false otherwise <BOOL>
 *
 * Example:
 * [cursorTarget, player, 0] call acre_sys_intercom_fnc_isIntercomAvailable
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomType"];

if (_vehicle != vehicle _unit) exitWith {false};

private _allowedPositions = (_vehicle getVariable [QGVAR(allowedPositions), []]) select _intercomType;
private _forbiddenPositions = (_vehicle getVariable [QGVAR(forbiddenPositions), []]) select _intercomType;

[_vehicle, _unit, _allowedPositions, _forbiddenPositions] call EFUNC(sys_core,hasAccessToVehicleSystem)
