/*
 * Author: ACRE2Team
 * Sets up side frequencies and babel settings from settings menu. Can be ran only once per mission.
 *
 * Arguments:
 * 1: Radio Order <NUMBER>
 * 0: Radio Class Name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [0, "ACRE_PRC343"] call acre_api_fnc_setupDefaultRadios;
 *
 * Public: No
 */
#include "script_component.hpp"

// Exit on dedicated server or headless client
if (!hasInterface) exitWith {};

// Run once after all 4 defaults have been initialized
if (!isNil QGVAR(hasSetupDefaultRadios) && {GVAR(hasSetupDefaultRadios)}) exitWith {};

params ["_order", "_radioClass"];

// Wait for all 4 defaults to be initialized
if (isNil QGVAR(defaultRadios)) then {
    GVAR(defaultRadios) = [];
};
GVAR(defaultRadios) set [_order, _radioClass];
if (count (GVAR(defaultRadios) select {_x isEqualType ""}) < 4) exitWith {};

// Apply default radios
private _addRadios = {
    // Don't regive radios if already given
    if (acre_player getVariable [QGVAR(hasGivenDefaultRadios), false]) exitWith {};
    acre_player setVariable [QGVAR(hasGivenDefaultRadios), true, true];

    private _cleanRadioList = [];
    if !("ACRE_PRC343" in _this) then {
        [acre_player, "ItemRadio"] call EFUNC(lib,removeGear);
        [acre_player, "ACRE_PRC343"] call EFUNC(lib,removeGear);
        _cleanRadioList = _this;
    } else {
        private _countDefaultRadios = 0;
        {
            if (_x == "ACRE_PRC343") then {
                _countDefaultRadios = _countDefaultRadios + 1;
                if (_countDefaultRadios > 1) then {
                    _cleanRadioList pushBack _x;
                };
            } else {
                _cleanRadioList pushBack _x;
            };
        } forEach _this;
    };

    TRACE_1("Adding Radios",_cleanRadioList);

    if (!((["ACRE_PRC77", "ACRE_PRC117F"] arrayIntersect _cleanRadioList) isEqualTo []) && {backpack acre_player == ""}) then {
        acre_player addBackpack "B_AssaultPack_khk";
    };

    {
        if (_x != "") then {
            acre_player addItem _x;
        };
    } forEach _cleanRadioList;
};

if (isNull acre_player) then {
    GVAR(defaultRadios) spawn {
        waitUntil {!isNull acre_player};
        _this call _addRadios;
    };
} else {
    GVAR(defaultRadios) call _addRadios;
};


GVAR(hasSetupDefaultRadios) = true;
