//#define DEBUG_MODE_FULL
#include "script_component.hpp"

private _factor = .7; 
private _doDefault = true;

if (!alive acre_player) exitWith {}; 

if(!isNil "ACRE_CustomVolumeControl") then {
	if((ACRE_CustomVolumeControl) isEqualType {}) then {
		_factor = [GVAR(VolumeControl_Level)] call ACRE_CustomVolumeControl;
		_doDefault = false;
	};
};

if(_doDefault) then {
	switch (GVAR(VolumeControl_Level)) do {
        case -2: 	{_factor = .1};
        //case -1.5:  {_factor = .3};
        case -1: 	{_factor = .4};
        //case -0.5:  {_factor = .7};
        case 0: 	{_factor = .7};
        //case 0.5:	{_factor = 1.05};
        case 1: 	{_factor = 1};
        //case 1.5:   {_factor = 1.2};
        case 2: 	{_factor = 1.3};
	};
};

private _currentVolume = call acre_api_fnc_getSelectableVoiceCurve;
if (!isNil "_currentVolume") then {
	#ifdef DEBUG_MODE_FULL
		acre_player sideChat format["Curv: %1  Fact: %2",_currentVolume,_factor];
	#endif
	
	if (_currentVolume != _factor) then  {
		[_factor] call acre_api_fnc_setSelectableVoiceCurve;
		#ifdef DEBUG_MODE_FULL
			acre_player sideChat format["Set volume factor: %1",_factor];
		#endif
	};
} else {
	#ifdef DEBUG_MODE_FULL
		acre_player sideChat "Custom curves not set currently, oh noes.";
	#endif
};
