#include "..\script_component.hpp"
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
TRACE_1("Start Get Channel",_frequency);
private _channel = ((_frequency * 10 - INDEX_CONVERSION) max 0) min MAX_DIAL_INDICES;
//Making it Arma-Float-Stable
_channel = [_channel, 1, 0] call CBA_fnc_formatNumber;
_channel = parseNumber _channel;
private _newFrequency = ([_channel] call FUNC(getFrequencyForChannel) select 0);
TRACE_2("End Get Channel",_channel,_newFrequency);
[_channel,_newFrequency]
