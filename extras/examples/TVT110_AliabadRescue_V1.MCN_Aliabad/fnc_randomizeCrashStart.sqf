#include "script_component.hpp"
private["_startPositions", "_units", "_start", "_spawnPos", "_startPos", "_wreckPosition"];
TRACE_1("enter", _this);
// This script randomizes the start for the units

_startPositions = _this select 0;
_units = _this select 1;


// Pick a random start position
_start = floor ( random ((count _startPositions)-1) ); 

_spawnPos = getPosATL (_units select 0);
_startPos = markerPos (_startPositions select _start);

TRACE_3("", _start, _spawnPos, _startPos);

{
	_x setPosATL [_startPos select 0, _startPos select 1, 0];
} foreach _units;

TRACE_1("DONE", "");
if(!isNil "wreck_1") then {
	wreck_1 setPosATL [(_startPos select 0)+50, (_startPos select 1)+10, 0];
	_wreckPosition = position wreck_1;
	
	smoke_1 = createVehicle ["test_EmptyObjectForSmoke",[(_wreckPosition select 0)+2, (_wreckPosition select 1), (_wreckPosition select 2)],[],0,"none"];
	smoke_2 = createVehicle ["test_EmptyObjectForSmoke",[(_wreckPosition select 0), (_wreckPosition select 1)+2, (_wreckPosition select 2)],[],0,"none"];
	smoke_3 = createVehicle ["test_EmptyObjectForSmoke",(position wreck_1),[],0,"none"];
};
// Move the destroyed vehicle to their location

// set spectator location
specloc setPos _startPos;