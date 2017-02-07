/*
 * Author: ACRE2Team
 * Use this to enable/disable the ignoring of antenna direction in the radio signal simulation.
 *
 * Arguments:
 * 0: Enable ignoring of antenna direction (omnidirectional radios) <BOOL>
 * 1: CBA Settings Call <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_api_fnc_ignoreAntennaDirection;
 *
 * Public: Yes
 */
#include "script_component.hpp"

if (!hasInterface) exitWith {false};

// @todo remove backwards compatibility in 2.7.0 (including second argument) and move function to sys_core
params ["_value", ["_CBASettingCall", false]];

// Backwards compatibility - block CBA settings if API function called directly
if (_CBASettingCall && {!isNil QGVAR(ignoreAntennaDirectionBlockCBASetting)}) exitWith {};

if (!_CBASettingCall) then {
    GVAR(ignoreAntennaDirectionBlockCBASetting) = true;
    ACRE_DEPRECATED(QFUNC(ignoreAntennaDirection),"2.7.0","CBA Settings");
    WARNING_1("%1 has been called directly and CBA Setting for it has been blocked!",QFUNC(ignoreAntennaDirection));
};

// Set
EGVAR(sys_signal,omnidirectionalRadios) = parseNumber _value;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",EGVAR(sys_core,interference),EGVAR(sys_core,fullDuplex),EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),EGVAR(sys_core,revealToAI));
