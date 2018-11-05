/*
 * Author: ACRE2Team
 * Sets whether AI can detect players speaking. This is randomized against the range of the unit, and takes into account the duration and quantity of speaking. In a nutshell, the closer you are to an AI unit and the more you speak - the better chance he has of hearing you. Also takes into account the distance a player's voice will travel.
 * Effects are local.
 *
 * Arguments:
 * 0: Reveal players to AI that speak <BOOL>
 * 1: CBA Settings Call <BOOL> (default: false)
 *
 * Return Value:
 * Are players that speak revealed to AI <BOOL>
 *
 * Example:
 * _status = [false] call acre_api_fnc_setRevealToAI
 *
 * Public: Yes
 */
#include "script_component.hpp"

if (!hasInterface) exitWith {false};

// @todo remove backwards compatibility in 2.7.0 (including second argument) and move function to sys_core
params ["_var", ["_CBASettingCall", false]];

// Backwards compatibility - block CBA settings if API function called directly
if (_CBASettingCall && {!isNil QGVAR(revealToAIBlockCBASetting)}) exitWith {};

if (!_CBASettingCall) then {
    GVAR(revealToAIBlockCBASetting) = true;
    ACRE_DEPRECATED(QFUNC(setRevealToAI),"2.7.0","CBA Settings");
    WARNING_1("%1 has been called directly and CBA Setting for it has been blocked!",QFUNC(setRevealToAI));
};

// Set
if !(_var isEqualType false) exitWith { false };

if (!EGVAR(sys_core,revealToAI) && _var) then {
    [] call EFUNC(sys_core,enableRevealAI);
} else {
    if (EGVAR(sys_core,revealToAI) && !_var) then {
        [] call EFUNC(sys_core,disableRevealAI);
    };
};

EGVAR(sys_core,revealToAI) = _var;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",EGVAR(sys_core,interference),EGVAR(sys_core,fullDuplex),EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),EGVAR(sys_core,revealToAI));

_var
