#include "script_component.hpp"
if (is3DEN || {!hasInterface || {!(GVAR(gesturesEnabled))}}) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "ace_common")) exitWith {}; // No ACE exit

GVAR(vestRadioArr) = call compile (GVAR(vestRadios));
GVAR(headsetRadioArr) = call compile (GVAR(headsetRadios));

["acre_startedSpeaking", {
    params ["_unit", "_onRadio", "_radio"];

    if (!_onRadio ||
        { !isNull objectParent _unit } ||
        { !(cameraView in ["INTERNAL","EXTERNAL"]) } ||
        { ace_common_isReloading } ||
        { isWeaponDeployed _unit } ||
        { animationState _unit in GVAR(blackListAnims) } ||
        { currentWeapon _unit in GVAR(binoClasses) } ) exitWith {};

    private _hasVest = vest _unit != "";
    private _hasHeadgear = headgear _unit != "";
    if (!_hasVest && !_hasHeadgear) exitWith {};

    private _baseRadio = _radio call acre_api_fnc_getBaseRadio;
    private _isVestRadio = (GVAR(vestRadioArr) findIf {_x isEqualTo _baseRadio}) != -1;
    private _isHeadsetRadio = (GVAR(headsetRadioArr) findIf {_x isEqualTo _baseRadio}) != -1;

    if (_hasVest && _isVestRadio) then {
        _unit playActionNow "acre_radio_vest";
        _unit setVariable [QGVAR(onRadio), true];
    };

    if (_hasHeadgear && _isHeadsetRadio) then {
        _unit playActionNow "acre_radio_helmet";
        _unit setVariable [QGVAR(onRadio), true];
    };
}] call CBA_fnc_addEventHandler;

["acre_stoppedSpeaking", {
    params ["_unit", "_onRadio"];

    if (!_onRadio) exitWith {};

    // If the unit started a reload while already talking, need to wait to finish to not delete a magazine
    [
        {!ace_common_isReloading},
        {
            // Wait 1 frame as mag doesn't report as loaded til events completed
            [FUNC(stopGesture), _this] call CBA_fnc_execNextFrame;
        },
        _unit
    ] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_addEventHandler;

acre_player addEventHandler ["GetInMan", {
    params ["_unit"];

    _unit call FUNC(stopGesture);
}];

acre_player addEventHandler ["WeaponDeployed", {
    params ["_unit", "_isDeployed"];

    if (_isDeployed) then {
        _unit call FUNC(stopGesture);
    };
}];
