//fnc_getCurrentChannel.sqf
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];
private ["_currentChannelId"];

_currentChannelId = HASH_GET(_radioData,"currentChannel");
if(isNil "_currentChannelId") then {
	_currentChannelId = 0;
};

_currentChannelId

