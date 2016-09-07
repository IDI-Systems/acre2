#include "script_component.hpp"
// Define the HVT start locations
GVAR(hvtStart) = ["mHvtStart_1", "mHvtStart_2", "mHvtStart_3", "mHvtStart_4", "mHvtStart_5", "mHvtStart_6", "mHvtStart_7", "mHvtStart_8"];

GVAR(opforStart) = ["opforStart_1", "opforStart_2", "opforStart_3", "opforStart_4", "opforStart_5", "opforStart_6", "opforStart_7"];
GVAR(opforStartAreas) = ["opforStartArea_1", "opforStartArea_2", "opforStartArea_3", "opforStartArea_4", "opforStartArea_5", "opforStartArea_6", "opforStartArea_7"];
GVAR(hvtUnits) = [hvt_1, hvt_2, hvt_3, hvt_4, hvt_5];
GVAR(teleportCount) = 0;if(isNil "MAX_TELEPORTS") then {	MAX_TELEPORTS = 3;};if(isNil "RANDOM_LANGUAGES") then {	RANDOM_LANGUAGES = false;};
if(isServer) then {
	[] call compile preprocessFileLineNumbers "server_init.sqf";	MISSION_STARTED = false;	publicVariable "MISSION_STARTED";
};
if(isDedicated) exitWith { };

// Hide the start positions
{_x setMarkerAlphaLocal 0} foreach GVAR(hvtStart);
{_x setMarkerAlphaLocal 0} foreach GVAR(opforStartAreas);
{_x setMarkerAlphaLocal 0} foreach GVAR(opforStart);

GVAR(init) = true;

[] spawn { 
	if(isNull player) then {		waitUntil { !isNull player };		waitUntil { !isNil "MISSION_STARTED" };
	} else {		MISSION_STARTED = false;	};		if(MISSION_STARTED) then {		[] call FUNC(onMissionStart);		[player] call compile preprocessFileLineNumbers "onPlayerDeath.sqf";	} else {
		waitUntil { !isNull player };		
		[] call compile preprocessFileLineNumbers "player_init.sqf";	};
};
