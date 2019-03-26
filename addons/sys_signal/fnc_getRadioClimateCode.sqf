#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the Longley-Rice (ITM) or ITWOM radio climate code for a specific map.
 *
 * Arguments:
 * 0: Map <STRING>
 *
 * Return Value:
 * Radio climate code <NUMBER>
 *
 * Example:
 * ["Altis"] call acre_sys_signal_fnc_getRadioClimateCode
 *
 * Public: No
 */

params [["_map", ""]];

if (_map == "") exitWith {MAP_CLIMATE_CONTINENTAL_TEMPERATE};

private _config = configProperties [configFile >> "CfgAcreSignal" >> "LongleyRiceRadioClimate", "isArray _x", true];
private _radioClimateCode = 5; // Continental Temperate is the default value

{
    private _confArray = getArray _x;
    _confArray params ["_code", "_mapArray"];

    if (_map in _mapArray) exitWith {
        _radioClimateCode = _code;
    };
} forEach _config;

_radioClimateCode
