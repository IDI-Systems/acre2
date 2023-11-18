/*
 * Author: ACRE2Team
 * Converts an dial index to a frequency
 * Clamps the dial index between 0 and maximum dial indices
 *
 * Arguments:
 * 0: The index of the dial position <INTEGER>
 *
 * Return Value <ARRAY>:
 * 0: The frequency
 * 1: The new dial index
 *
 * Example:
 * [["", 0], 0] call acre_sys_ws38_fnc_getFrequency
 *
 * Public: No
 */

 params ["_channel"];

_channel = (_channel min 0) max MAX_DIAL_INDICES;
private _frequency = (_channel+INDEX_CONVERSION)/10;
//Making it Arma-Float-Stable
_frequency = [_frequency, 1, 2] call CBA_fnc_formatNumber;
_frequency = parseNumber _frequency;

[_frequency,_channel]
