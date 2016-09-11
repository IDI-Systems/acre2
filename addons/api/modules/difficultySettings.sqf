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

params ["_logic", "_units", "_activated"];

if (!_activated) exitWith {};

ACRE_DEPRECATED("Difficulty Settings module","2.4.0","CBA Settings");

TRACE_1("enter", _this);

_signalLoss = _logic getVariable["SignalLoss", true];
_fullDuplex = _logic getVariable["FullDuplex", false];
_interference = _logic getVariable["Interference", true];
_ignoreAntennaDirection = _logic getVariable["IgnoreAntennaDirection", false];

if(!_signalLoss) then {
    [0.0] call acre_api_fnc_setLossModelScale;
};
if(_fullDuplex) then {
    [true] call acre_api_fnc_setFullDuplex;
};
if(!_interference) then {
    [false] call acre_api_fnc_setInterference;
};
if(_ignoreAntennaDirection) then {
    [true] call acre_api_fnc_ignoreAntennaDirection;
};
