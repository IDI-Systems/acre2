/*
 * Author: ACRE2Team
 * This function generically sets up a mission so that each side will have their own radios as well as speak their own separate languages. Further API calls will be needed to allow them to speak to each other, or configure specific intermingling channels.
 * This function should allow for the most basic and common TVT and gameplay setups; allowing for different radios that do not interfere, as well as different languages.
 * Call this on all clients.
 *
 * Arguments:
 * 0: Babel - true to set up a unique babel language for each side. <BOOLEAN>
 * 1: Radio - true to set up different frequencies for each side by using different presets. <BOOLEAN>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true, true] call acre_api_fnc_setupMission;
 *
 * Public: Yes
 */
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
