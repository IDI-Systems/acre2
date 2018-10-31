#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if a unit is in the given intercom network of a vehicle.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * Unit is in the given intercom network <BOOL>
 *
 * Example:
 * [cursorTarget, acre_player, 0] call acre_sys_intercom_fnc_isInIntercom
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_intercomNetwork"];

private _varName = [_vehicle, _unit] call FUNC(getStationVariableName);

if (_varName isEqualTo "") exitWith { false };

INTERCOM_DISCONNECTED < ([_vehicle, _unit, _intercomNetwork, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration))
