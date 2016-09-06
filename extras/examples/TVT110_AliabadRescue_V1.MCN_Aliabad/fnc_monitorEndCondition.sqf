#include "script_component.hpp"


GVAR(endTime) = diag_tickTime + 7200; // End timer
FUNC(do_monitor) = {
	private["_rescueComplete", "_rescueLocationPos"];
	
	if(diag_tickTime > GVAR(endTime)) exitWith {
		["missionEnd", ["timeLimit"]] call CBA_fnc_globalEvent;
		[GVAR(serverPFH)] call CBA_fnc_removePerFrameHandler;
	};
	
	_rescueComplete = true;
	_rescueLocationPos = markerPos "bluforStartArea";
	{
		private["_hvt"];
		_hvt = _x;
		if(!isNil "_hvt") then {
			if(!isNull _hvt) then {
				if( (_hvt distance _rescueLocationPos) > 150) exitWith { 
					_rescueComplete = false;
				};
			};
		};
	} forEach GVAR(hvtUnits);
	
	if(_rescueComplete) exitWith {
		["missionEnd", ["rescue"]] call CBA_fnc_globalEvent;
		[GVAR(serverPFH)] call CBA_fnc_removePerFrameHandler;
	};
	
	// Check deaths
	if((GVAR(killTrack) select 0) > (GVAR(bluforStartCount) * 0.70)) exitWith {
		["missionEnd", ["bluforDeath"]] call CBA_fnc_globalEvent;
		[GVAR(serverPFH)] call CBA_fnc_removePerFrameHandler;
	};
	if((GVAR(killTrack) select 1) > (GVAR(opforStartCount) * 0.70)) exitWith {
		["missionEnd", ["opforDeath"]] call CBA_fnc_globalEvent;
		[GVAR(serverPFH)] call CBA_fnc_removePerFrameHandler;
	};
	if((GVAR(killTrack) select 2) >= GVAR(civilianStartCount)) exitWith {
		["missionEnd", ["hvtDeath"]] call CBA_fnc_globalEvent;
		[GVAR(serverPFH)] call CBA_fnc_removePerFrameHandler;
	};
};


GVAR(serverPFH) = [FUNC(do_monitor), 10, []] call CBA_fnc_addPerFrameHandler;