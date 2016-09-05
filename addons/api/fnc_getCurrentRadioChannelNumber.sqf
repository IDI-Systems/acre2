#include "script_component.hpp"

private["_radioId", "_channelNumber"];
_radioId = [] call FUNC(getCurrentRadio);
if(_radioId == "") exitWith { -1 };

_channelNumber = [_radioId] call FUNC(getRadioChannel);

if(isNil "_channelNumber") exitWith { -1 };
_channelNumber = _channelNumber + 1;
_channelNumber