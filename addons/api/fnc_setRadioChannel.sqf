#include "script_component.hpp"

params ["_radioId", "_channelNumber"];

if( !(_radioId isEqualType "")) exitWith { -1 };

if(_channelNumber isEqualType 0) then {
    _channelNumber = _channelNumber - 1;
    [_radioId, "setCurrentChannel", _channelNumber] call EFUNC(sys_data,dataEvent);
} else {
    // Should we handle a channel NAME and find it, and change it?!?
    
};

true