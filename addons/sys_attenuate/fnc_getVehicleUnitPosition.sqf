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

private["_vehicle", "_ret"];
params["_unit"];

_ret = "other";

if( (vehicle _unit) == _unit) exitWith {
    nil
};
_vehicle = vehicle _unit;


if(((commander _vehicle) == _unit) && (((assignedVehicleRole _unit) select 0) == "Turret")) exitWith {
    _ret = "commander";
    _ret
};

if((driver _vehicle) == _unit) exitWith {
    _ret = "driver";
    _ret
};

if((gunner _vehicle) == _unit) exitWith {
    _ret = "gunner";
    _ret
};

if((Count (assignedVehicleRole _unit)>1)) exitWith {
    _ret = "gunner";
    _ret
};

if(((assignedVehicleRole _unit) select 0) == "Cargo") exitWith {
    _ret = "cargo";
    _ret
};

_ret
