//fnc_setOnOffState.sqf
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];

HASH_SET(_radioData, "radioOn", _eventData);
/*if(_radioId == acre_sys_radio_currentRadioDialog) then {
    if(_eventData == 0) then {
        
    } else {
        
    };
};*/

