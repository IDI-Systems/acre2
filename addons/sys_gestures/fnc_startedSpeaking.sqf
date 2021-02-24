#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles stopping the radio gesture.
 *
 * Arguments:
 * 0: Unit that started speaking <OBJECT>
 * 1: Is unit on radio <BOOL>
 * 2: Radio unit is currently using <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player,true,acre_prc343_id_1"] call acre_sys_gesture_fnc_startedSpeaking
 *
 * Public: No
 */

params ["_unit", "_onRadio", "_radio"];

if (!_onRadio ||
    { !isNull objectParent _unit } ||
    { cameraView in GVAR(disallowedViews) } ||
    { ace_common_isReloading } ||
    { isWeaponDeployed _unit } ||
    { animationState _unit in GVAR(blackListAnims) } ||
    { currentWeapon _unit in GVAR(binoClasses) } ) exitWith {};

private _hasVest = vest _unit != "";
private _hasHeadgear = headgear _unit != "";
if (!_hasVest && !_hasHeadgear) exitWith {};

private _isHeadset = (_radio call EFUNC(api,getBaseRadio)) call FUNC(isHeadsetRadio);

if (_hasVest && !_isHeadset) then {
    _unit playActionNow ([QGVAR(vest), QGVAR(vest_noADS)] select GVAR(stopADS));
    _unit setVariable [QGVAR(onRadio), true];
};

if (_hasHeadgear && _isHeadset) then {
    _unit playActionNow ([QGVAR(helmet), QGVAR(helmet_noADS)] select GVAR(stopADS));
    _unit setVariable [QGVAR(onRadio), true];
};
