/*
 * Author: ACRE2Team
 * Sets up side frequencies and babel settings from settings menu. Can be ran only once per mission.
 *
 * Arguments:
 * 0: Unique Side Frequencies <BOOL>
 * 1: Babel <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [false, 0] call acre_api_fnc_setupFrequenciesAndBabel;
 *
 * Public: No
 */
#include "script_component.hpp"

// Run once
if (!isNil QGVAR(hasSetupFrequenciesAndBabel) && {GVAR(hasSetupFrequenciesAndBabel)}) exitWith {};

params ["_uniqueFrequencies", "_babel"];

// Unique frequencies are handled in FUNC(setupMission), no need to handle it here

// No babel
if (_babel == 0) exitWith {
    [false, _uniqueFrequencies] call FUNC(setupMission);
};

// One language per side babel
if (_babel == 1) exitWith {
    [true, _uniqueFrequencies] call FUNC(setupMission);
};

// One language per side + common babel (Zeus gets ALL Languages, including "Common")
// Handle the babel setup via an array, so the bool is set to false
if (_babel == 2) exitWith {
    [false, _uniqueFrequencies] call FUNC(setupMission);
    [
        [east, "Opfor", "Common"],
        [west, "Blufor", "Common"],
        [independent, "Indepedent", "Common"],
        [civilian, "Civilian", "Common"],
        [sideLogic, "Opfor", "Blufor", "Indepedent", "Civilian", "Common"]
    ] call FUNC(babelSetupMission);
};

GVAR(hasSetupFrequenciesAndBabel) = true;
