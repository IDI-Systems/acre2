#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the description of the currently selected channel. Used in the transmission hint.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "getChannelDescription" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Description of the channel in the form "Block x - Channel y" <STRING>
 *
 * Example:
 * ["ACRE_WS38_ID_1", "getChannelDescription", [], [], false] call acre_sys_ws38_fnc_getChannelDescription
 *
 * Public: No
 */

params ["_radioId", "",  "", "", ""];

private _hashData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);

private _frequency = HASH_GET(_hashData,"frequencyTX");

private _channel = ([_frequency] call FUNC(getChannelForFrequency)) select 0;
private _displayFrequency = (_channel + INDEX_CONVERSION)/10;
private _description = format["Channel: %1 Frequency: %2 MHz (%3)", _channel, _displayFrequency, _frequency];

_description
