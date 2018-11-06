#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This function generically sets up a mission so that each side will have their own radios as well as
 * speak their own separate languages. Further API calls will be needed to allow them to speak to each
 * other, or configure specific intermingling channels.
 * This function should allow for the most basic and common TVT and gameplay setups; allowing for different
 * radios that do not interfere, as well as different languages. Call this on all clients.
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

params [
    ["_setupBabel", true, [true]],
    ["_setupPresets", true, [true]]
];

if ((typeName _setupBabel) != "BOOL") exitWith { false };
if ((typeName _setupPresets) != "BOOL") exitWith { false };

if (_setupbabel) then {
    [true] call FUNC(babelSetupMission);
};

if !(_setupPresets && hasInterface) exitWith {};

[{!isNull acre_player}, {
    switch (side acre_player) do {
        case east: {
            ["ACRE_PRC343", "default2" ] call FUNC(setPreset);
            ["ACRE_PRC77", "default2" ] call FUNC(setPreset);
            ["ACRE_PRC117F", "default2" ] call FUNC(setPreset);
            ["ACRE_PRC152", "default2" ] call FUNC(setPreset);
            ["ACRE_PRC148", "default2" ] call FUNC(setPreset);
            ["ACRE_PRC77", "default2" ] call FUNC(setPreset);
        };
        case west: {
            ["ACRE_PRC343", "default3" ] call FUNC(setPreset);
            ["ACRE_PRC77", "default3" ] call FUNC(setPreset);
            ["ACRE_PRC117F", "default3" ] call FUNC(setPreset);
            ["ACRE_PRC152", "default3" ] call FUNC(setPreset);
            ["ACRE_PRC148", "default3" ] call FUNC(setPreset);
            ["ACRE_PRC77", "default3" ] call FUNC(setPreset);
        };
        case independent: {
            ["ACRE_PRC343", "default4" ] call FUNC(setPreset);
            ["ACRE_PRC77", "default4" ] call FUNC(setPreset);
            ["ACRE_PRC117F", "default4" ] call FUNC(setPreset);
            ["ACRE_PRC152", "default4" ] call FUNC(setPreset);
            ["ACRE_PRC148", "default4" ] call FUNC(setPreset);
            ["ACRE_PRC77", "default4" ] call FUNC(setPreset);
        };
        default {
            ["ACRE_PRC343", "default" ] call FUNC(setPreset);
            ["ACRE_PRC77", "default" ] call FUNC(setPreset);
            ["ACRE_PRC117F", "default" ] call FUNC(setPreset);
            ["ACRE_PRC152", "default" ] call FUNC(setPreset);
            ["ACRE_PRC148", "default" ] call FUNC(setPreset);
            ["ACRE_PRC77", "default" ] call FUNC(setPreset);
        };
    };
}] call CBA_fnc_waitUntilAndExecute;
