//fnc_handlePTTUp.sqf
#include "script_component.hpp"

private ["_volume", "_channelNumber", "_channelData", "_rxOnly"];
params["_radioId"];

_channelNumber = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
_channelData = [_radioId, _channelNumber] call FUNC(getChannelDataInternal);

_rxOnly = HASH_GET(_channelData, "rxOnly");
if(_rxOnly) exitWith {
	false
};

_volume = [_radioId, "getVolume"] call EFUNC(sys_data,dataEvent);
[_radioId, "Acre_GenericClickOff", [0,0,0], [0,1,0], _volume] call EFUNC(sys_radio,playRadioSound);
SCRATCH_SET(_radioId, "PTTDown", false);
true;