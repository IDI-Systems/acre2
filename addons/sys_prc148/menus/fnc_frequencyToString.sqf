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

private ["_mhz", "_khz", "_khzString", "_khzArray", "_i", "_hz"];
params["_frequency"];

_mhz = floor _frequency;
_khz = round((_frequency*100000)-((floor _frequency)*100000));
//_khz = _khz*100;
_khzString = str _khz;
_khzArray = toArray _khzString;
for "_i" from 1 to 5-(count _khzArray) do {
    _khzString = "0" + _khzString;
};
_hz = (str _mhz) + _khzString;

_hz;
