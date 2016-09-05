#include "script_component.hpp"

// This function should setup the appropriate default babel as well as radio presets per side
// [ setupBabel, setupPerSideRadios] call acre_api_fnc_setupMission;
// [ true/false, true/false]

params["_setupBabel","_setupPresets"];

if((typeName _setupBabel) != "BOOL") exitWith { false };
if((typeName _setupPresets) != "BOOL") exitWith { false };

if(_setupbabel) then {
	[ true ] call FUNC(babelSetupMission);
};

if(_setupPresets) then {
	if(hasInterface) then {
		[] spawn {
			waitUntil { !isNull acre_player };

			_side = side acre_player;
			switch _side do { 
				case east: { 
					["ACRE_PRC343", "default2" ] call acre_api_fnc_setPreset;
					["ACRE_PRC77", "default2" ] call acre_api_fnc_setPreset;
					["ACRE_PRC117F", "default2" ] call acre_api_fnc_setPreset;
					["ACRE_PRC152", "default2" ] call acre_api_fnc_setPreset;
					["ACRE_PRC148", "default2" ] call acre_api_fnc_setPreset;
				};
				case west: { 
					["ACRE_PRC343", "default3" ] call acre_api_fnc_setPreset;
					["ACRE_PRC77", "default3" ] call acre_api_fnc_setPreset;
					["ACRE_PRC117F", "default3" ] call acre_api_fnc_setPreset;
					["ACRE_PRC152", "default3" ] call acre_api_fnc_setPreset;
					["ACRE_PRC148", "default3" ] call acre_api_fnc_setPreset;
				};
				case independent: { 
					["ACRE_PRC343", "default4" ] call acre_api_fnc_setPreset;
					["ACRE_PRC77", "default4" ] call acre_api_fnc_setPreset;
					["ACRE_PRC117F", "default4" ] call acre_api_fnc_setPreset;
					["ACRE_PRC152", "default4" ] call acre_api_fnc_setPreset;
					["ACRE_PRC148", "default4" ] call acre_api_fnc_setPreset;
				};
				default { 
					["ACRE_PRC343", "default" ] call acre_api_fnc_setPreset;
					["ACRE_PRC77", "default" ] call acre_api_fnc_setPreset;
					["ACRE_PRC117F", "default" ] call acre_api_fnc_setPreset;
					["ACRE_PRC152", "default" ] call acre_api_fnc_setPreset;
					["ACRE_PRC148", "default" ] call acre_api_fnc_setPreset;
				};
			};
		};
	};
};