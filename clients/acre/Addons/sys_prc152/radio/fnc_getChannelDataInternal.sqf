#include "script_component.hpp"
private ["_channels", "_optChannelId", "_opt", "_currentChannelId", "_channel"];
TRACE_1("", _this);

params["_radioId"];
_channels = [_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent);
_optChannelId = [_radioId, "getState", "optChannelId"] call EFUNC(sys_data,dataEvent);
_opt = [_radioId, "getState", "optChannelData"] call EFUNC(sys_data,dataEvent);

_currentChannelId = -1;
if((count _this) > 1) then {
	_currentChannelId = _this select 1;
} else {
	_currentChannelId = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
};

if(!(isNil "_optChannelId") && !(isNil "_opt")) then {
	if(_optChannelId != _currentChannelId) then {
		// The current channel is not the same as the operational channel so just return
		_channel =  HASHLIST_SELECT(_channels, _currentChannelId);
		_channel
	} else {
		// Get the actual channel data, then overlay it with the operational data
		_channel =  HASHLIST_SELECT(_channels, _currentChannelId);
		
		{
			private["_value", "_key"];
			_key = _x;
			_value = HASH_GET(_channel, _x);
			
			HASH_SET(_channel, _key, _value);
		} forEach HASH_KEYS(_opt);
		
		_channel
	};
} else {
		_channel =  HASHLIST_SELECT(_channels, _currentChannelId);
		_channel
};