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

TRACE_1("343 getChannelData", _this);

params["_radioId", "_event", "_eventData", "_radioData"];

private _channelNumber = _eventData;
private _channels = HASH_GET(_radioData, "channels");
private _channel = HASHLIST_SELECT(_channels, _channelNumber);

private _return = HASH_CREATE;
HASH_SET(_return, "mode", "singleChannelPRR");
HASH_SET(_return, "frequencyTX", HASH_GET(_channel, "frequencyTX"));
HASH_SET(_return, "frequencyRX", HASH_GET(_channel, "frequencyRX"));
HASH_SET(_return, "power", 100);
_return
