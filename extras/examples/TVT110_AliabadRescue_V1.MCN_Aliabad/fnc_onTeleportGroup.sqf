#include "script_component.hpp"

//if(!isServer) exitWith { false };
private["_group", "_unit", "_markerName", "_position", "_teamNumber"];
_teamNumber = _this select 0;
_markerName = _this select 1;

_position = markerPos _markerName;
_unit = nil;
switch _teamNumber do {
	case 1: { if(!isNil "OPFOR_TEAMONE_LEADER") 	then { _unit = OPFOR_TEAMONE_LEADER; } };
	case 2: { if(!isNil "OPFOR_TEAMTWO_LEADER") 	then { _unit = OPFOR_TEAMTWO_LEADER; } };
	case 3: { if(!isNil "OPFOR_TEAMTHREE_LEADER")	then { _unit = OPFOR_TEAMTHREE_LEADER; } };
	case 4: { if(!isNil "OPFOR_TEAMFOUR_LEADER") 	then { _unit = OPFOR_TEAMFOUR_LEADER; } };
	case 5: { if(!isNil "OPFOR_TEAMFIVE_LEADER") 	then { _unit = OPFOR_TEAMFIVE_LEADER; } };
	case 6: { if(!isNil "OPFOR_TEAMSIX_LEADER") 	then { _unit = OPFOR_TEAMSIX_LEADER; } };
};
if(isNil "_unit") exitWith {};

_group = group _unit;
{
	if(local _x) then {
		_x enableSimulation false;
		_x setPosATL [(_position select 0), (_position select 1), 0];
		_x enableSimulation true;
	};
	
} foreach (units _group);