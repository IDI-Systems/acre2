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

params["_vehicle", "_self", "_unit"];

private _ret = 0;

private _attenuateClass = [_vehicle] call FUNC(getVehicleAttenuateClass);
private _selfPositionClass = [_self, _vehicle] call FUNC(getVehiclePositionClass);
private _selfTurnedOut = isTurnedOut _self;
private _unitTurnedOut = false;
private _unitPositionClass = _unit;

if(IS_OBJECT(_unit)) then {
    _unitPositionClass = [_unit, _vehicle] call FUNC(getVehiclePositionClass);
    _unitTurnedOut = isTurnedOut _unitTurnedOut;
};

// Get this value based on whether we are turned out or inside
private _selfRet = 0;
private _unitRet = 0;

if(!(isNil "_selfTurnedOut")) then {
    // load up the attenuation class from the main root
    if(_selfTurnedOut) then {
        _selfRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _selfPositionClass >> "turnedout" >> _unitPositionClass >> "attenuationValue");
    } else {
        _selfRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _selfPositionClass >> "inside" >> _unitPositionClass >> "attenuationValue");
    };
} else {
    _selfRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _selfPositionClass >> "inside" >> _unitPositionClass >> "attenuationValue");
};
if(!(isNil "_unitTurnedOut")) then {
    // load up the attenuation class from the main root
    if(_selfTurnedOut) then {
        _unitRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _unitPositionClass >> "turnedout" >> _selfPositionClass >> "attenuationValue");
    } else {
        _unitRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _unitPositionClass >> "inside" >> _selfPositionClass >> "attenuationValue");
    };
} else {
    _unitRet = getNumber ( configFile >> "CfgAcreAttenuation" >> _attenuateClass >> _unitPositionClass >> "inside" >> _selfPositionClass >> "attenuationValue");
};
_ret = _selfRet + _unitRet;


TRACE_1("ret", _ret);

if(isNil "_ret") then {
    _ret = 0;
};

_ret
