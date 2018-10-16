#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Provides functionality to allow for easy setup of side-specific languages.
 * An array is provided for each configurable side which specifies the languages that side can speak.
 *
 * Arguments:
 * N: Array of sides and languages <ARRAY>
 *   0: Side <SIDE>
 *   1: Language display name <STRING>
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * [ [west, "English", "French"], [east, "Russian"], [civilian, "French"] ] call acre_api_fnc_babelSetupMission;
 * [ [west, "English", "French"], [east, "Russian", "French" ] ] call acre_api_fnc_babelSetupMission;
 *
 * Public: Yes
 */

// Variables are provided as
// [ [side, languages], [side, languages] ] call acre_api_fnc_babelSetupMission;
// OR
// Give all sides a different language per TVT
// [ true/false ] call acre_api_fnc_babelSetupMission

// Babel is not maintained on non-clients.
if (!hasInterface) exitWith {};

_this spawn {
    if ((_this select 0) isEqualType false) exitWith {
        params ["_flag"];
        // Bail with a default setup
        // Wait for the mission to initialize first
        if (_flag) then {
            _flag spawn {
                ["east", "Opfor"] call FUNC(babelAddLanguageType);
                ["west", "Blufor"] call FUNC(babelAddLanguageType);
                ["ind", "Indepedent"] call FUNC(babelAddLanguageType);
                ["civ", "Civilian"] call FUNC(babelAddLanguageType);
                ["logic", "Zeus"] call FUNC(babelAddLanguageType);
                //something acre_player
                waitUntil { !isNull acre_player };
                switch (side acre_player) do {
                    case east: {
                        ["east"] call FUNC(babelSetSpokenLanguages);
                    };
                    case west: {
                        ["west"] call FUNC(babelSetSpokenLanguages);
                    };
                    case independent: {
                        ["ind"] call FUNC(babelSetSpokenLanguages);
                    };
                    case civilian: {
                        ["civ"] call FUNC(babelSetSpokenLanguages);
                    };
                    default {
                        ["east", "west", "ind", "civ", "logic"] call FUNC(babelSetSpokenLanguages);
                    };
                };
            };
        };

        true
    };
    if (!((_this select 0) isEqualType [])) exitWith { false };
    // They provided an array of spoken languages
    // Wait for player to be initialized
    waitUntil { !isNull acre_player };
    private _languages = [];
    {
        // Delete the side information in order to add the languages to the unit if the side matches
        // (used below). If not removed at this point, it would be treated as a language.
        private _curSide = _x deleteAt 0;

        private _sideLanguages = [];
        private _languageCount = (count _x);
        {
            if ((_languages pushBackUnique _x) != -1) then {
                [_x, _x] call FUNC(babelAddLanguageType);
            };
            _sideLanguages pushBack _x;
        } forEach _x;

        // acre_player may not ready yet?
        if (_curSide == (side acre_player) ) then {
            _sideLanguages call FUNC(babelSetSpokenLanguages);
        };
    } forEach _this;

    true
};
