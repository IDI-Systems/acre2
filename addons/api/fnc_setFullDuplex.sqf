/*
 * Author: ACRE2Team
 * Sets the duplex of radio transmissions. If set to true, it means that you will receive transmissions even while talking and multiple people can speak at the same time.
 *
 * Arguments:
 * 0: Enable full duplex <BOOL>
 * 1: CBA Settings Call <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_api_fnc_setFullDuplex;
 *
 * Public: Yes
 */
#include "script_component.hpp"

if (!hasInterface) exitWith {false};

// @todo remove backwards compatibility in 2.7.0 (including second argument) and move function to sys_core
params ["_value", ["_CBASettingCall", false]];

// Backwards compatibility - block CBA settings if API function called directly
if (_CBASettingCall && {!isNil QGVAR(fullDuplexBlockCBASetting)}) exitWith {};

if (!_CBASettingCall) then {
    GVAR(fullDuplexBlockCBASetting) = true;
    ACRE_DEPRECATED(QFUNC(setFullDuplex),"2.7.0","CBA Settings");
    WARNING_1("%1 has been called directly and CBA Setting for it has been blocked!",QFUNC(setFullDuplex));
};

// Set
EGVAR(sys_core,fullDuplex) = _value;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",EGVAR(sys_core,interference),EGVAR(sys_core,fullDuplex),EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),EGVAR(sys_core,revealToAI));
