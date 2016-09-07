/*
 * Author: ACRE2Team
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

params["_unit", "_vehicle"];

private _ret = "other";
private _attenuateClass = [_vehicle] call FUNC(getVehicleAttenuateClass);
private _positionList = getArray ( configFile >> "CfgAcreAttenuation" >>_attenuateClass >> "positions");

// figure out what position they are in, weee
if((count _positionList) < 2) exitWith {
    _ret
};

// Determine position
private _position = [_unit] call FUNC(getVehicleUnitPosition);
if((_position in _positionList)) then {
    _ret = _position;
};

_ret
