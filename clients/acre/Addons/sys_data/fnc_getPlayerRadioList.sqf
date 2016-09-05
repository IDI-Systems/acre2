//fnc_getPlayerRadioList.sqf
#include "script_component.hpp"

private _radioList = [];

if(alive acre_player) then {
	private _weapons = [acre_player] call EFUNC(lib,getGear);
	{
		if(getNumber(configFile >> "CfgWeapons" >> _x >> "acre_isUnique") == 1) then {
			_radioList pushBack _x;
		};
	} forEach _weapons;
	if (ACRE_ACTIVE_RADIO != "") then {
		_radioList pushBackUnique ACRE_ACTIVE_RADIO;
	};
} else {
	_radioList = ACRE_SPECTATOR_RADIOS;
};

_radioList