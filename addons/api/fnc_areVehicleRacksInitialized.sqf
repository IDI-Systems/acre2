#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whether the vehicle racks have been initialized for the given vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Vehicle racks initialized <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_api_fnc_areVehicleRacksInitialized
 *
 * Public: Yes
 */

params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle) exitWith {
    WARNING("Non-defined vehicle passed as argument.");
    false
};

_vehicle getVariable [QEGVAR(sys_rack,initialized), false]
