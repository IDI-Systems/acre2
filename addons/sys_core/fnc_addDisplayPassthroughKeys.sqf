#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds key handling compatibility to a custom display, which otherwise does not pass through CBA keybinds.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Successfully added passthrough key handling <BOOL>
 *
 * Example:
 * [display] call acre_sys_core_fnc_addDisplayPassthroughKeys
 *
 * Public: Yes
 */

params ["_display"];

if (isNull _display) exitWith {false};

_display displayAddEventHandler ["KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

    // Radio PTT
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "AltPTTKey1"] call CBA_fnc_getKeybind) select 8)) then {
        [0] call FUNC(handleMultiPttKeyPress);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "AltPTTKey2"] call CBA_fnc_getKeybind) select 8)) then {
        [1] call FUNC(handleMultiPttKeyPress);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "AltPTTKey3"] call CBA_fnc_getKeybind) select 8)) then {
        [2] call FUNC(handleMultiPttKeyPress);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "DefaultPTTKey"] call CBA_fnc_getKeybind) select 8)) then {
        [-1] call FUNC(handleMultiPttKeyPress);
    };

    // Channel Switch
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "PreviousChannel"] call CBA_fnc_getKeybind) select 8)) then {
        [-1] call FUNC(switchChannelFast);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "NextChannel"] call CBA_fnc_getKeybind) select 8)) then {
        [1] call FUNC(switchChannelFast);
    };

    // Babel
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "BabelCycleKey"] call CBA_fnc_getKeybind) select 8)) then {
        [] call FUNC(cycleLanguage);
    };

    // Radio Ear
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "RadioLeftEar"] call CBA_fnc_getKeybind) select 8)) then {
        [-1] call FUNC(switchRadioEar);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "RadioBothEars"] call CBA_fnc_getKeybind) select 8)) then {
        [0] call FUNC(switchRadioEar);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "RadioRightEar"] call CBA_fnc_getKeybind) select 8)) then {
        [1] call FUNC(switchRadioEar);
    };

    // Head Set
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "HeadSet"] call CBA_fnc_getKeybind) select 8)) then {
        [] call FUNC(toggleHeadset);
    };

    // Antenna Direction
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "acre_AntennaDirToggle"] call CBA_fnc_getKeybind) select 8)) then {
        [] call EFUNC(sys_components,toggleAntennaDir);
    };

    false
}];

_display displayAddEventHandler ["KeyUp", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

    // Radio PTT
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "AltPTTKey1"] call CBA_fnc_getKeybind) select 8)) then {
        [0] call FUNC(handleMultiPttKeyPressUp);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "AltPTTKey2"] call CBA_fnc_getKeybind) select 8)) then {
        [1] call FUNC(handleMultiPttKeyPressUp);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "AltPTTKey3"] call CBA_fnc_getKeybind) select 8)) then {
        [2] call FUNC(handleMultiPttKeyPressUp);
    };
    if ([_key, [_shift, _ctrl, _alt]] in ((["ACRE2", "DefaultPTTKey"] call CBA_fnc_getKeybind) select 8)) then {
        [-1] call FUNC(handleMultiPttKeyPressUp);
    };

    false
}];


private _return = true;

// God Mode
if (isClass (configFile >> "CfgPatches" >> "acre_sys_godmode")) then {
    _return = [_display] call EFUNC(sys_godmode,addDisplayPassthroughKeys);
};

_return
