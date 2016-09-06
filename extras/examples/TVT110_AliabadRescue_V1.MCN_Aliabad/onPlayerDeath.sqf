#include "script_component.hpp"

_unit = _this select 0;
camera_location = getPosATL _unit;


if(MISSION_STARTED) then {
	if(isServer) exitWith {
		private["_count"];
		
		switch (side _unit) do { 
			case west: { 
				_count = GVAR(killTrack) select 0;
				_count = _count + 1;
				GVAR(killTrack) set[0, _count];
			};
			case east: {
				_count = GVAR(killTrack) select 1;
				_count = _count + 1;
				GVAR(killTrack) set[1, _count];
			};
			case civilian: {
				_count = GVAR(killTrack) select 2;
				_count = _count + 1;
				GVAR(killTrack) set[2, _count];
			};
		};
	};
	
	if(_unit != player) exitWith { };
	
	[true] call acre_api_fnc_setSpectator;
	[] spawn {
		_has_spec = false;
		_message = "You are dead.\nEntering spectator mode...";
		while { true } do { 
			titleText [_message, "BLACK", 0.2];
			sleep 1;
			titleText [_message, "BLACK FADED", 10];
			
			if (!_has_spec) then { [player] join grpNull; };
			while {!alive player} do {sleep 0.2};
			
			player setPos (getpos specpen);
			if (!_has_spec) then { 
				[] execVM "spectator.sqf"; 
				_has_spec = true; 
			} else { 
				titleText [_message, "BLACK IN", 0.2]; 
			};
			player setCaptive true;
			player addEventHandler ["HandleDamage", {false}];
			{player removeMagazine _x} forEach magazines player;
			removeAllWeapons player;
			removeAllItems player;
			
			while {alive player} do {sleep 0.2};
		};
	};
	
} else {
	if(_unit != player) exitWith { };
	_unit spawn {
		private["_loadout", "_savePosition"];
		_savePosition = getPosATL _this;
		_loadout =  _this getVariable ["tb3_loadout", ""];
		waitUntil { alive player };
		_loadout set[0, player];
		_loadout call tb3_fLoadout;
		player setPosATL _savePosition;
	};
};
