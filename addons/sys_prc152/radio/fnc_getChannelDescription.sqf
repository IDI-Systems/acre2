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

params ["_radioId"];

private _channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
private _channels = [_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent);
private _channel = HASHLIST_SELECT(_channels, _channelNumber);

private _channelLabel = HASH_GET(_channel, "description");

format ["%1 - %2", [_channelNumber + 1, 2] call CBA_fnc_formatNumber, _channelLabel]
