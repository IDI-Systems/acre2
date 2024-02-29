#include "script_component.hpp"
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

FUNC(_channelNamesForPresets) = {
    params ["_channelNames", "_presetNames"];

    TRACE_1("enter",_this);
    if (_presetNames isNotEqualTo []) then {
        {
            if (_x != "") then {
                private _channelName = _x;
                private _channelNumber = _forEachIndex;
                {
                    _x params ["_radioClass", "_presetName"];

                    // Filter out preset channel if greater than supported channel (eg. ACRE_PRC77 only has 2 presets)
                    private _presetData = [_radioClass, _presetName] call EFUNC(sys_data,getPresetData);
                    if (!isNil "_presetData" && {count HASH_GET(_presetData,"channels") >= _channelNumber}) then {
                        // Example: ["ACRE_PRC117F", "default3", 10, "label", "SUPPORT"]
                        #ifdef DEBUG_MODE_FULL
                            diag_log text format ["%1, %2, %3, %4, %5", _radioClass, _presetName, _channelNumber + 1, "label", _channelName];
                        #endif
                        [_radioClass, _presetName, _channelNumber + 1, "label", _channelName] call FUNC(setPresetChannelField);
                    };
                } forEach _presetNames;
            };
        } forEach _channelNames;
    };
};

private _channelNamesNoSides = {
    private _presetNames = [];
    TRACE_1("Naming Channels",_this);
    {
        private _presetName = [_x] call FUNC(getPreset);
        _presetNames pushBack [_x, _presetName];
    } forEach ((call FUNC(getAllRadios)) select 0);

    TRACE_1("Configuring radio for presets",_presetNames);
    [_this, _presetNames] call FUNC(_channelNamesForPresets);
};

private _channelNamesForPresetGroup = {
    params ["_channelNames", "_presetName"];

    private _presetNames = [];
    {
        _presetNames pushBack [_x, _presetName];
    } forEach ((call FUNC(getAllRadios)) select 0);

    TRACE_1("Configuring radio for presets",_presetNames);
    [_channelNames, _presetNames] call FUNC(_channelNamesForPresets);
};


params ["_logic", "_units", "_activated"];

if (!_activated) exitWith {};

TRACE_1("enter",_this);

private _sideNumber = _logic getVariable ["SideSelect", false];
private _channelNames = [
    _logic getVariable ["Channel_1", ""],
    _logic getVariable ["Channel_2", ""],
    _logic getVariable ["Channel_3", ""],
    _logic getVariable ["Channel_4", ""],
    _logic getVariable ["Channel_5", ""],
    _logic getVariable ["Channel_6", ""],
    _logic getVariable ["Channel_7", ""],
    _logic getVariable ["Channel_8", ""],
    _logic getVariable ["Channel_9", ""],
    _logic getVariable ["Channel_10", ""]
];

private _setupSides = false;
{
    if (_x isKindOf QGVAR(basicMissionSetup)) exitWith {
        _setupSides = _x getVariable ["RadioSetup", false];
        TRACE_1("Dedicated basic mission module - checking sides configuration",_setupSides);
    };
} forEach (allMissionObjects "logic");

if (!_setupSides) exitWith {
    _channelNames call _channelNamesNoSides;
    true
};

switch (_sideNumber) do {
    // All
    case 1: {
        _channelNames call _channelNamesNoSides;
    };
    // West
    case 2: {
        [_channelNames, "default3"] call _channelNamesForPresetGroup;
    };
    // East
    case 3: {
        [_channelNames, "default2"] call _channelNamesForPresetGroup;
    };
    // Indy
    case 4: {
        [_channelNames, "default4"] call _channelNamesForPresetGroup;
    };
    // Civie
    case 5: {
        [_channelNames, "default"] call _channelNamesForPresetGroup;
    };
    default {};
};

true
