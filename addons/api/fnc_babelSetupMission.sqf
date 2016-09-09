/*
 * Author: ACRE2Team
 * Provides functionality to allow for easy setup of side-specific languages. An array is provided for each configurable side which specifies the languages that side can speak.
 *
 * Arguments:
 * N: Array where the first element is a side and the following elements are language diplay names. <ARRAY>
 *
 * Return Value:
 * Setup succesful <BOOLEAN>
 *
 * Example:
 * [ [west, "English", "French"], [east, "Russian"], [civilian, "French"] ] call acre_api_fnc_setupMission;
 *
 * Public: Yes
 */
#include "script_component.hpp"

// Variables are provided as
// [ [side, languages], [side, languages] ] call acre_api_fnc_babelSetupMission;
// OR
// Give all sides a different language per TVT
// [ true/false ] call acre_api_fnc_babelSetupMission

// Babel is not maintained on non-clients.
if (!hasInterface) exitWith {};

_this spawn {
    if((_this select 0) isEqualType false) exitWith {
        params["_flag"];
        // Bail with a default setup
        // Wait for the mission to initialize first
        if(_flag) then {
            _flag spawn {
                ["east", "Opfor"] call acre_api_fnc_babelAddLanguageType;
                ["west", "Blufor"] call acre_api_fnc_babelAddLanguageType;
                ["ind", "Indepedent"] call acre_api_fnc_babelAddLanguageType;
                ["civ", "Civilian"] call acre_api_fnc_babelAddLanguageType;
                ["logic", "Zeus"] call acre_api_fnc_babelAddLanguageType;
                //something acre_player
                waitUntil { !isNull acre_player };
                _side = side acre_player;
                switch _side do {
                    case east: {
                        ["east"] call acre_api_fnc_babelSetSpokenLanguages;
                    };
                    case west: {
                        ["west"] call acre_api_fnc_babelSetSpokenLanguages;
                    };
                    case independent: {
                        ["ind"] call acre_api_fnc_babelSetSpokenLanguages;
                    };
                    case civilian: {
                        ["civ"] call acre_api_fnc_babelSetSpokenLanguages;
                    };
                    default {
                        ["east", "west", "ind", "civ", "logic"] call acre_api_fnc_babelSetSpokenLanguages;
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
        private _curSide = _x select 0;
        private _sideLanguages = [];
        private _languageCount = (count _x);
        for [{_i=1}, {_i < _languageCount}, {_i=_i+1}] do {
            private _curLanguage = _x select _i;

            if((_languages pushBackUnique _curLanguage) != -1) then {
                [_curLanguage, _curLanguage] call acre_api_fnc_babelAddLanguageType;
            };
            _sideLanguages pushBack _curLanguage;
        };
        //acre_player may not ready yet?
        if(_curSide == (side acre_player) ) then {
            _sideLanguages call acre_api_fnc_babelSetSpokenLanguages;
        };
    } forEach _this;

    true
};
