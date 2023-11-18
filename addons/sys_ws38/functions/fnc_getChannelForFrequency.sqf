/*
 * Author: ACRE2Team
 * Converts a frequency to a dial index.
 * Clamping it in the possible dial range.
 *
 * Arguments:
 * 0: Frequency to get the dial index of <FLOAT>
 *
 * Return Value <ARRAY>:
 * 0: The dial index
 * 1: The new frequency
 *
 * Example:
 * [["", 0], 0] call acre_sys_ws38_fnc_getDialIndex
 *
 * Public: No
 */

params ["_frequency"];

private _channel = ((_frequency * 10 - INDEX_CONVERSION) max 0) min MAX_DIAL_INDICES;
//Making it Arma-Float-Stable
_channel = [_frequency, 1, 0] call CBA_fnc_formatNumber;
_channel = parseNumber _frequency;

[_channel,[_channel] call FUNC(getFrequency) select 0]
