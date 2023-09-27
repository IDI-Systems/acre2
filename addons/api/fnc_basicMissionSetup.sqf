#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * For use by the ACRE API basicMissionSetup module.
 *
 * Arguments:
 * 0: Logic <OBJECT>
 * 1: Units <ARRAY>
 * 2: Activated <BOOLEAN>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AcreModules_fnc_basicMissionSetup;
 *
 * Public: No
 */

params [
    ["_logic", objNull, [objNull]],
    ["_units", [], [[]]],
    ["_activated", true, [true]]
];

// Run once
if (!isNil QGVAR(basicMissionSetup) && {GVAR(basicMissionSetup)}) exitWith {};

TRACE_1("enter", _this);

// Basic setup
private _setupRadios = _logic getVariable ["RadioSetup", false];
private _setupBabel = _logic getVariable ["BabelSetup", 0];

// Unique frequencies are handled in FUNC(setupMission), no need to handle it here
switch (_setupBabel) do {
    // No babel
    case 0: {
        [false, _setupRadios] call FUNC(setupMission);
    };
    // One language per side babel
    case 1: {
        [true, _setupRadios] call FUNC(setupMission);
    };
    // One language per side + common babel (Zeus gets ALL Languages, including "Common")
    // Handle the babel setup via an array, so the bool is set to false
    case 2: {
        [false, _setupRadios] call FUNC(setupMission);
        [
            [east, "Opfor", "Common"],
            [west, "Blufor", "Common"],
            [independent, "Indepedent", "Common"],
            [civilian, "Civilian", "Common"],
            [sideLogic, "Opfor", "Blufor", "Indepedent", "Civilian", "Common"]
        ] call FUNC(babelSetupMission);
    };
    // Something went wrong
    default {
        [false, _setupRadios] call FUNC(setupMission);
        hint "The Babel System is not set correctly. Please double check the settings in the module you placed."
    };
};

GVAR(basicMissionSetup) = true;


// Default radios
if (!hasInterface) exitWith {true};

private _defaultRadios = [
    _logic getVariable ["DefaultRadio", ""],
    _logic getVariable ["DefaultRadio_Two", ""],
    _logic getVariable ["DefaultRadio_Three", ""],
    _logic getVariable ["DefaultRadio_Four", ""]
];

private _addRadios = {
    params ["_defaultRadios", "_player"];

    // Don't regive radios if already given
    if (_player getVariable [QGVAR(basicMissionSetup), false]) exitWith {};
    _player setVariable [QGVAR(basicMissionSetup), true, true];

    private _cleanRadioList = [];
    private _defaultRadio = EGVAR(sys_radio,defaultRadio);
    if !(_defaultRadio in _defaultRadios) then {
        [_player, "ItemRadio"] call EFUNC(sys_core,removeGear);
        [_player, _defaultRadio] call EFUNC(sys_core,removeGear);
        _cleanRadioList = _defaultRadios;
    } else {
        private _countDefaultRadios = 0;
        {
            if (_x == _defaultRadio) then {
                _countDefaultRadios = _countDefaultRadios + 1;
                if (_countDefaultRadios > 1) then {
                    _cleanRadioList pushBack _x;
                };
            } else {
                _cleanRadioList pushBack _x;
            };
        } forEach _defaultRadios;

    };

    TRACE_1("Adding Radios", _cleanRadioList);

    if ((backpack _player == "") && {(["ACRE_PRC77", "ACRE_PRC117F"] arrayIntersect _cleanRadioList) isNotEqualTo []}) then {
        _player addBackpack "B_AssaultPack_khk";
    };

    {
        if (_x != "") then {
            _player addItem _x;
        };
    } forEach _cleanRadioList;
};

[{
    !isNull acre_player
}, {
    [_this select 0, acre_player] call (_this select 1);
}, [_defaultRadios, _addRadios]] call CBA_fnc_waitUntilAndExecute;

true
