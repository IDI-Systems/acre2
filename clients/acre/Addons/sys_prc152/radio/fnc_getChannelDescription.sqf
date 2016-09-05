//fnc_getChannelDescription.sqf
#include "script_component.hpp"
params["_radioId"];

_channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
_channels = [_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent);
_channel = HASHLIST_SELECT(_channels, _channelNumber);

_channelLabel = HASH_GET(_channel, "description");

_description = format["%1 - %2", ([(_channelNumber+1), 2] call CBA_fnc_formatNumber), _channelLabel];

_description