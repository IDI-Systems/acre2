 
#include "script_component.hpp"

params["_radio"];

if(isNil "_radio") exitWith {};

if(!([_radio] call EFUNC(sys_data,isRadioInitialized))) exitWith {};

private _volume = [_radio, "getVolume"] call EFUNC(sys_data,dataEvent);

_volume