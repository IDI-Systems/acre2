#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc148_fnc_frequencyToString
 *
 * Public: No
 */

params ["_frequency"];

private _mhz = floor _frequency;
private _khz = round ((_frequency*100000) - ((floor _frequency)*100000));
//_khz = _khz*100;
private _khzString = str _khz;
private _khzArray = toArray _khzString;
for "_i" from 1 to 5 - (count _khzArray) do {
    _khzString = "0" + _khzString;
};
private _hz = (str _mhz) + _khzString;

_hz;
