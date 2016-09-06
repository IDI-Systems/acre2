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

private["_attenuateClass", "_ret", "_parent", "_positionClass", "_playerTurnedOut"];
params["_vehicle", "_unit"];

TRACE_2("Getting outside attenuation", _vehicle, _unit);

_ret = 0;
_playerTurnedOut = false;
_positionClass = _unit;
_attenuateClass = [_vehicle] call FUNC(getVehicleAttenuateClass);
if(IS_OBJECT(_unit)) then {
    _positionClass = [_unit, _vehicle] call FUNC(getVehiclePositionClass);

    _playerTurnedOut = isTurnedOut _unit;//[_unit] call FUNC(isTurnedOut);
    TRACE_3("turned out status", _attenuateClass, _positionClass, _playerTurnedOut);
};
if(!(isNil "_playerTurnedOut")) then {
    if(_playerTurnedOut) then {
        _ret = getNumber ( configFile >> "CfgAcreAttenuation" >>_attenuateClass >> _positionClass >> "turnedout" >> "attenuateOutside");
    } else {
        _ret = getNumber ( configFile >> "CfgAcreAttenuation" >>_attenuateClass >> _positionClass >> "inside" >> "attenuateOutside");
    };
} else {
    // load up the attenuation class from the main root
    _ret = getNumber ( configFile >> "CfgAcreAttenuation" >>_attenuateClass >> _positionClass >> "inside" >> "attenuateOutside");
};
TRACE_1("ret", _ret);

if(isNil "_ret") then {
    _ret = 0;
};

_ret
