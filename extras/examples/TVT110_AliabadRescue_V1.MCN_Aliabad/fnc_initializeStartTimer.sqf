#include "script_component.hpp"


// Start timer for areas of operation at beginning
[] spawn {
	private["_waitTime"];
	
	waitUntil { time > 0 };
	
	_waitTime = diag_tickTime + 900;
	while { ( diag_tickTime < _waitTime && (count GVAR(sideReady)) < 2 ) } do {
		if(!MISSION_STARTED) then { 
			[] call FUNC(monitorStartAreas);
		};
	};

	sleep 5;
	["missionStart", [true]] call CBA_fnc_globalEvent; 
};
