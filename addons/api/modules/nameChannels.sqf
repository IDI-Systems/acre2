/*
 * Author: ACRE2Team
 * For use by the ACRE API nameChannels module.
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
 * [] call AcreModules_fnc_nameChannels;
 *
 * Public: No
 */
#include "script_component.hpp"

FUNC(_channelNamesForPresets) = {
    params["_channelNames", "_presetNames"];

    TRACE_1("enter", _this);
    if((count _presetNames) > 0) then {
        {
            private _channelName = _x;
            private _channelNumber = _forEachIndex;
            if(_channelName != "") then {
                {
                    //["ACRE_PRC117F",["default3"],10,"label","SUPPORT"]
                    #ifdef DEBUG_MODE_FULL
                        diag_log text format["%1,%2,%3,%4,%5", (_x select 0), (_x select 1), 
                        _channelNumber+1, 
                        "label", _channelName];
                    #endif
                    [(_x select 0), (_x select 1), 
                    _channelNumber+1, 
                    "label", _channelName] call acre_api_fnc_setPresetChannelField;
                } forEach _presetNames;
            };
        } forEach _channelNames;
    };
};

FUNC(_channelNamesNoSides) = {
    private _presetNames = [];
    TRACE_1("Naming Channels",_this);
    {
        private _presetName = [_x] call acre_api_fnc_getPreset;

        if(!isNil "_presetName") then {
            if(_presetName isEqualType "") then {
                _presetNames pushBack [_x, _presetName];
            };
        };
    } forEach ["ACRE_PRC152", "ACRE_PRC148", "ACRE_PRC117F"];
    
    TRACE_1("Configuring radio for presets", _presetNames);
    
    [_this, _presetNames] call FUNC(_channelNamesForPresets);
};

FUNC(_channelNamesForPresetGroup) = {
    params ["_channelNames", "_presetName"];
    
    private _presetNames = [];
    {
        _presetNames pushBack [_x, _presetName];
    } forEach ["ACRE_PRC152", "ACRE_PRC148", "ACRE_PRC117F"];
    
    TRACE_1("Configuring radio for presets", _presetNames);
    
    [_channelNames, _presetNames] call FUNC(_channelNamesForPresets);
};


params["_logic", "_units", "_activated"];

private _setupSides = false;

if (!_activated) exitWith {};

TRACE_1("enter", _this);

private _sideNumber = _logic getVariable["SideSelect", false];

private _channelNames = [];
_channelNames set[0, ( _logic getVariable["Channel_1", ""] ) ];
_channelNames set[1, ( _logic getVariable["Channel_2", ""] ) ];
_channelNames set[2, ( _logic getVariable["Channel_3", ""] ) ];
_channelNames set[3, ( _logic getVariable["Channel_4", ""] ) ];
_channelNames set[4, ( _logic getVariable["Channel_5", ""] ) ];
_channelNames set[5, ( _logic getVariable["Channel_6", ""] ) ];
_channelNames set[6, ( _logic getVariable["Channel_7", ""] ) ];
_channelNames set[7, ( _logic getVariable["Channel_8", ""] ) ];
_channelNames set[8, ( _logic getVariable["Channel_9", ""] ) ];
_channelNames set[9, ( _logic getVariable["Channel_10", ""] ) ];


_logics = allMissionObjects "logic";
if( count _logics > 0) then {
    { 
        if(_x isKindOf QUOTE(GVAR(basicMissionSetup)) ) exitWith {
            _setupSides = _x getVariable["RadioSetup", false];
            TRACE_1("Dedicated basic mission module, checking sides configuration", _setupSides);
        };
    } forEach _logics;
};

if(_setupSides) then {
    switch _sideNumber do {
        // All 
        case 1: {
            _channelNames call FUNC(_channelNamesNoSides);
        };
        // West
        case 2: { 
            [_channelNames, "default3"] call FUNC(_channelNamesForPresetGroup);
        };
        // East
        case 3: { 
            [_channelNames, "default2"] call FUNC(_channelNamesForPresetGroup);
        };
        // Indy
        case 4: { 
            [_channelNames, "default4"] call FUNC(_channelNamesForPresetGroup);
        };
        // Civie
        case 5: { 
            [_channelNames, "default"] call FUNC(_channelNamesForPresetGroup);
        };
    };
} else {
    _channelNames call FUNC(_channelNamesNoSides);
};



true