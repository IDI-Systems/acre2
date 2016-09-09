/*
 * Author: ACRE2Team
 * For use by the ACRE API difficultySettings module.
 *
 * Arguments:
 * 0: Logic <OBJECT>
 * 1: Units <ARRAY>
 * 2: Activated <BOOLEAN>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AcreModules_fnc_difficultySettings;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_logic", "_units", "_activated"];

if (!_activated) exitWith {};

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