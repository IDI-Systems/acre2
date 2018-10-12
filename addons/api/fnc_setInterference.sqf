/*
 * Author: ACRE2Team
 * Sets whether transmissions will interfere with each other. This, by default, causes signal loss when multiple people are transmitting on the same frequency.
 *
 * Arguments:
 * 0: Enable interference <BOOL>
 * 1: CBA Settings Call <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_api_fnc_setInterference;
 *
 * Public: Yes
 */
#include "script_component.hpp"

if (!hasInterface) exitWith {false};

// @todo remove backwards compatibility in 2.7.0 (including second argument) and move function to sys_core
params ["_value", ["_CBASettingCall", false]];

// Backwards compatibility - block CBA settings if API function called directly
if (_CBASettingCall && {!isNil QGVAR(interferenceBlockCBASetting)}) exitWith {};

if (!_CBASettingCall) then {
    GVAR(interferenceBlockCBASetting) = true;
    ACRE_DEPRECATED(QFUNC(setInterference),"2.7.0","CBA Settings");
    WARNING_1("%1 has been called directly and CBA Setting for it has been blocked!",QFUNC(setInterference));
};

// Set
EGVAR(sys_core,interference) = _value;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",EGVAR(sys_core,interference),EGVAR(sys_core,fullDuplex),EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),EGVAR(sys_core,revealToAI));
