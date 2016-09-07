#include "script_component.hpp"


GVAR(started) = true;
titleFadeOut 0.1;
titleText ["THE PLANE HAS CRASHED, THE SEARCH HAS NOW BEGUN!", "PLAIN", 3];
hint "MISSION BEGUN!";

// Hide all the zone markers
"opforStartArea" setMarkerAlphaLocal 0;
"bluforStartArea" setMarkerAlphaLocal 0;
{_x setMarkerAlphaLocal 0; } foreach GVAR(opforStartAreas);

// Set start counts globally
{
	switch (side _x) do {
		case west: { GVAR(bluforStartCount) = GVAR(bluforStartCount) + 1; };
		case east: { GVAR(opforStartCount) = GVAR(opforStartCount) + 1; };
		case civilian: { GVAR(civilianStartCount) = GVAR(civilianStartCount) + 1; };
	};
} forEach allUnits;

// allow the civlians to move
{ 
	private["_hvt"];
	_hvt = _x;
	if(!isNil "_hvt") then {
		if(!isNull _hvt) then {
			if(local _hvt) then {
				_hvt enableSimulation true;
				player enableSimulation true;
			};
		};
	};
} forEach GVAR(hvtUnits);

// Stop restriction handlers
if(isServer) then {
	// Randomize the Civlian HVT Start Position
	[GVAR(hvtStart), GVAR(hvtUnits)] call FUNC(randomizeCrashStart);
	
	// Start monitoring for the rescue end conditions
	[] call FUNC(monitorEndCondition);
	
	MISSION_STARTED = true;
	publicVariable "MISSION_STARTED";
	
	deleteVehicle blufor_board;
	deleteVehicle opfor_board;
};

