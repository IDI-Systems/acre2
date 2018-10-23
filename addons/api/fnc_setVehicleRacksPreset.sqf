#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the preset name used for initialising the vehicle racks.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (default: objNull)
 * 1: Preset name <STRING> (default: "")
 *
 * Return Value:
 * Successfully set the vehicle preset <BOOL>
 *
 * Example:
 * [cursorTarget, "default4"] call acre_api_fnc_setVehicleRacksPreset
 *
 * Public: Yes
 */

params [
    ["_vehicle", objNull, [objNull]],
    ["_presetName", "", [""]]
];

if (isNull _vehicle) exitWith {
    WARNING("Vehicle is null");
    false
};

if (_presetName isEqualTo "") exitWith {
    WARNING("Empty preset name introduced");
    false
};

_vehicle setVariable [QEGVAR(sys_rack,vehicleRacksPreset), _presetName, true];

true
