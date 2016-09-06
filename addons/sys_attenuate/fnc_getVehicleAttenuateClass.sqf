/*
 * Author: AUTHOR
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

private["_vehicleClass", "_ret"];
params["_vehicle"];

_vehicleClass = typeOf _vehicle;

_ret = nil;

// we recursive search up CfgVehicles until we find a vehicle with a

while { _vehicleClass != "" } do {
    // check here
    _ret = getText ( configFile >> "CfgVehicles" >> _vehicleClass >> "ACRE_attenuationClass" );

    if(_ret != "") exitWith {
        false
    };
    _vehicleClass = configName (inheritsFrom ( configFile >> "CfgVehicles" >> _vehicleClass));
};
_ret
