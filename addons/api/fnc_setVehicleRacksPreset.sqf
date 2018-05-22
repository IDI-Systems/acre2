/*
 * Author: ACRE2Team
 * Sets the preset name used for initialising the vehicle racks.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (Default: objNull)
 * 1: Preset name <STRING> (Default: "")
 *
 * Return Value:
 * Successfully set the vehicle preset <BOOL>
 *
 * Example:
 * [cursorTarget, "default4"] call acre_api_fnc_setVehicleRacksPreset
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], ["_presetName", ""]];

if (isNull _vehicle) exitWith {
    ERROR("Vehicle is null");
    false
};

if (_presetName isEqualTo "") exitWith {
    ERROR("Empty preset name introduced");
    false
};

_vehicle setVariable [QEGVAR(sys_rack,vehicleRacksPreset), _presetName, true];

true
