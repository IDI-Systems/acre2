/*
 * Author: ACRE2Team
 * Gets the preset name used for initialising the vehicle racks.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (default: objNull)
 *
 * Return Value:
 * Preset name ("" if undefined) <STRING>
 *
 * Example:
 * [cursorTarget] call acre_api_fnc_getVehicleRacksPreset
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], ["_presetName", ""]];

if (isNull _vehicle) exitWith {
    WARNING("Vehicle is null");
    ""
};

_vehicle getVariable [QEGVAR(sys_rack,vehicleRacksPreset), ""]
