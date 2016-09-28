#include "script_component.hpp"


// Disable civilian movement for the first 5 minutes
if((side player) == civilian) then {
	player enableSimulation false;
};	

if(isNil "o_platoon_commander" || isNil "b_platoon_commander") exitWith {
	diag_log text format["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
	diag_log text format["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
	diag_log text format["Mission requires an opfor and blufor commander to run correctly!!!!!"];
	diag_log text format["MISSION REQUIRES ALL CIVILIANS SLOTTED!!!!!"];
	diag_log text format["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
	diag_log text format["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
	
	[] spawn {
		while { true } do { 
			hint "ERROR: Mission requires an opfor and blufor commander to run correctly!!!!!";
			sleep 1;
		};
	};
};

// Commander specific start actions and options
if(player == b_platoon_commander) then {
	GVAR(start_board) = blufor_board;
	_actionId = blufor_board addAction ["SIGNAL BLUFOR READY",
							{ [] call FUNC(doReady) }];
	player setVariable[QGVAR(readyActionId), _actionId, false];
};

if(player == o_platoon_commander) then {

	{_x setMarkerAlphaLocal 1} foreach GVAR(opforStartAreas);

	GVAR(start_board) = opfor_board;
	_actionId = opfor_board addAction ["SIGNAL REDFOR READY", 
							{ [] call FUNC(doReady) }
	];
	if(MAX_TELEPORTS > 0) then {
		player setVariable[QGVAR(readyActionId), _actionId, false];
		
		_actionId = opfor_board addAction ["Select Team 1 Location", 
								{ [1] call FUNC(doSelectTeamStart) }
		];
		player setVariable[QGVAR(selectTeamLocation_1), _actionId, false];
		
		_actionId = opfor_board addAction ["Select Team 2 Location", 
								{ [2] call FUNC(doSelectTeamStart) }
		];
		player setVariable[QGVAR(selectTeamLocation_2), _actionId, false];
		
		_actionId = opfor_board addAction ["Select Team 3 Location", 
								{ [3] call FUNC(doSelectTeamStart) }
		];
		player setVariable[QGVAR(selectTeamLocation_3), _actionId, false];
		
		_actionId = opfor_board addAction ["Select Team 4 Location", 
								{ [4] call FUNC(doSelectTeamStart) }
		];
		player setVariable[QGVAR(selectTeamLocation_4), _actionId, false];
		
		_actionId = opfor_board addAction ["Select MG Team 1 Location", 
								{ [5] call FUNC(doSelectTeamStart) }
		];
		player setVariable[QGVAR(selectTeamLocation_5), _actionId, false];
		
		_actionId = opfor_board addAction ["Select Mg Team 2 Location", 
								{ [6] call FUNC(doSelectTeamStart) }
		];
		player setVariable[QGVAR(selectTeamLocation_6), _actionId, false];
	};
};

// Change markers
switch (side player) do {
	case east: { 
		"bluforStartArea" setMarkerAlphaLocal 0;
	};
	case west: { 
		"opforStartArea" setMarkerAlphaLocal 0;
	};
	case civilian: { 
	
	};
};

// Initialize briefings
switch (side player) do {
	case east: { [] call compile preprocessFileLineNumbers "briefing\opfor.sqf"; };
	case west: { [] call compile preprocessFileLineNumbers "briefing\blufor.sqf"; };
	case civilian: { [] call compile preprocessFileLineNumbers "briefing\civilian.sqf"; };
};

// Initialize babel and ACRE radios
["ru", "Russian"] call acre_api_fnc_babelAddLanguageType;
["en", "English"] call acre_api_fnc_babelAddLanguageType;
_random = floor (random 100);
switch (side player) do {
	case east: { 
		["ru"] call acre_api_fnc_babelSetSpokenLanguages;
		if(_random > 75  && RANDOM_LANGUAGES) then {
			["ru", "en"] call acre_api_fnc_babelSetSpokenLanguages;
			["ru"] call acre_api_fnc_babelSetSpeakingLanguage;
		} else {
			["ru", ""] call acre_api_fnc_babelSetSpokenLanguages;
		};
		["ACRE_PRC77", "default3" ] call acre_api_fnc_setPreset;
		//["ACRE_PRC343", "default3" ] call acre_api_fnc_setPreset;
	};
	case west: {
		if(_random > 90 && RANDOM_LANGUAGES) then {
			["ru", "en"] call acre_api_fnc_babelSetSpokenLanguages;
			["en"] call acre_api_fnc_babelSetSpeakingLanguage;
		} else {
			["en"] call acre_api_fnc_babelSetSpokenLanguages;
		};
		
		["ACRE_PRC343", "default" ] call acre_api_fnc_setPreset;
		["ACRE_PRC117F", "default2" ] call acre_api_fnc_setPreset;
		["ACRE_PRC152", "default2" ] call acre_api_fnc_setPreset;
	};
	case civilian: { 
		["en"] call acre_api_fnc_babelSetSpokenLanguages;
		["en"] call acre_api_fnc_babelSetSpeakingLanguage;
		
		["ACRE_PRC343", "default" ] call acre_api_fnc_setPreset;
		["ACRE_PRC152", "default2" ] call acre_api_fnc_setPreset;
	};
};
