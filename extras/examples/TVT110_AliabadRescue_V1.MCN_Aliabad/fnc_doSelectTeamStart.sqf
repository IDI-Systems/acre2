#include "script_component.hpp"

TRACE_1("doSelectTeamStart", _this);

FUNC(onMapClicked) = {
	private["_clickedPosition", "_teamNumber", "_markerPosition", "_closest"];
	_clickedPosition = _this select 0;
	_teamNumber = _this select 1;
	
	_closest = [];
	{
		_markerPosition = markerPos _x;
		if(_clickedPosition distance _markerPosition < 12) then {
			PUSH(_closest, _x);
		};
	} forEach GVAR(opforStartAreas);
	
	if(count _closest > 0) then {
		_selected = _closest select 0;
		private["_actionId", "_varStr"];
		
		hint format["Team %1 teleported. %1 teleports remaining.", 
			_teamNumber, 
			(MAX_TELEPORTS - GVAR(teleportCount))];
			
		// Select the location for the team and teleport them, and delete the action
		["teleportGroup", [_teamNumber, _selected] ] call CBA_fnc_globalEvent;
		GVAR(teleportCount) = GVAR(teleportCount) + 1;
		
		_varStr = format["%1_%2", QGVAR(selectTeamLocation), _teamNumber];
		_actionId = player getVariable [_varStr, -1];
		opfor_board removeAction _actionId;
		openMap [false, false];

		if(GVAR(teleportCount) >= MAX_TELEPORTS) exitWith {
			// MAX TELEPORTS REMOVE THE ACTIONS
			hint "Maximum teleports reached";
			for [{_i=1}, {_i<=6}, {_i=_i+1}] do {
				_varStr = format["%1_%2", QGVAR(selectTeamLocation), _i];
				_actionId = player getVariable [_varStr, -1];
				opfor_board removeAction _actionId;
			};
		};		
	};
	
	
};
_functionName = QUOTE(FUNC(onMapClicked));
_stringScript = format["[_pos,_this] call %1", _functionName];
(_this select 0) onMapSingleClick _stringScript;
openMap [true, false];

