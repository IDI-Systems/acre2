#include "script_component.hpp"

private["_radioId"];
params["_channelNumber"];

if( !(_channelNumber isEqualType 0)) exitWith { false };

_radioId = [] call FUNC(getCurrentRadio);
if(_radioId == "") exitWith { false };

[_radioId, _channelNumber] call FUNC(setRadioChannel);

true