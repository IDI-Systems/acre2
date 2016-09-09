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
#include "script_component.hpp"

params ["_logic", "_units", "_activated"];

// Run once
if(!isNil QUOTE(GVAR(basicMissionSetup))) then {
    if(GVAR(basicMissionSetup)) exitWith {};
};

TRACE_1("enter", _this);

_setupRadios = _logic getVariable["RadioSetup", false];
_setupBabel = _logic getVariable["BabelSetup", 0];

_defaultRadios = [];
_defaultRadios set[0, ( _logic getVariable["DefaultRadio", ""] ) ];
_defaultRadios set[1, ( _logic getVariable["DefaultRadio_Two", ""] ) ];
_defaultRadios set[2, ( _logic getVariable["DefaultRadio_Three", ""] ) ];
_defaultRadios set[3, ( _logic getVariable["DefaultRadio_Four", ""] ) ];

//_setupRadios is handles in the acre_api_fnc_setupMission. No need to handle it here
switch (_setupBabel) do {
    //We don't want the babel system
    case 0: {
        [false, _setupRadios] call acre_api_fnc_setupMission;
    };
    //We want the babel system to be set to one language per side
    case 1: {
        [true, _setupRadios] call acre_api_fnc_setupMission;
    };
    //We need to handle the babel setup via an array, so the bool is set to false
    //Zeus gets ALL Languages, including "Common"
    case 2: {
        [false, _setupRadios] call acre_api_fnc_setupMission;
        [
            [east, "Opfor", "Common"],
            [west, "Blufor", "Common"],
            [independent, "Indepedent", "Common"],
            [civilian, "Civilian", "Common"],
            [sideLogic, "Opfor", "Blufor", "Indepedent", "Civilian", "Common"]
        ] call acre_api_fnc_babelSetupMission;
    };
    //This shouldn't be reached. If so, we throw an error.
    default {
        [false, _setupRadios] call acre_api_fnc_setupMission;
        hint "The Babel System is not set correctly. Please double check the settings in the module you placed."
    };
};

FUNC(_addRadios) = {
    private _unit = acre_player;
    // Don't regive radios if already given
    if (_unit getVariable [QGVAR(basicMissionSetup),false]) exitWith {};
    _unit setVariable [QGVAR(basicMissionSetup),true,true];

    private _cleanRadioList = [];
    
    if(!("ACRE_PRC343" in _this) ) then {
        [_unit, "ItemRadio"] call EFUNC(lib,removeGear);
        [_unit, "ACRE_PRC343"] call EFUNC(lib,removeGear);
        
        _cleanRadioList = _this;
    } else {
        private _countDefaultRadios = 0;
        
        { 
            if(_x == "ACRE_PRC343") then { 
                _countDefaultRadios = _countDefaultRadios + 1; 
                if(_countDefaultRadios > 1) then {
                    _cleanRadioList pushBack _x;
                };
            } else {
                _cleanRadioList pushBack _x;
            };
        } forEach _this;
        
    };

    TRACE_1("Adding Radios", _cleanRadioList);
    
    if( ("ACRE_PRC77" in _cleanRadioList) || ("ACRE_PRC117F" in _cleanRadioList) ) then {
        if( (backpack _unit) == "") then {
            _unit addBackpack "B_AssaultPack_khk";
        };
    };
    {
        private _radioType = _x;
        TRACE_1("", _radioType);
        
        if(!isNil "_radioType") then {
            if(_radioType != "") then {
                _unit addItem _radioType;
            };
        };
    } forEach _cleanRadioList;    
};

if(hasInterface) then {
    if(isNull acre_player) then {
        _defaultRadios spawn {
            waituntil { !isNull acre_player };
            _this call FUNC(_addRadios);
        };
    } else {
        _defaultRadios call FUNC(_addRadios);
    };
};

GVAR(basicMissionSetup) = true;

true