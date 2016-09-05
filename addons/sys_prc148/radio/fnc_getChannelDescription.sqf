//fnc_getChannelDescription.sqf
#include "script_component.hpp"
params["_radioId"];

_group = ([_radioId, "getState", "groups"] call EFUNC(sys_data,dataEvent)) select ([_radioId, "getState", "currentGroup"] call EFUNC(sys_data,dataEvent));
_channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
_groupLabel = _group select 0;
_channels = [_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent);
_channel = HASHLIST_SELECT(_channels, _channelNumber);

_channelLabel = HASH_GET(_channel, "label");

_description = format["%1 - %2", _groupLabel, _channelLabel];

_description