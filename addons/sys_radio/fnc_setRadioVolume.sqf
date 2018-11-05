#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the radio volume.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 * 1: Volume between 0 and 1 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_RPC343_ID_1", 0.8] call acre_sys_radio_fnc_setRadioVolume
 *
 * Public: No
 */

params ["_radio", "_volume"];

if (isNil "_radio") exitWith {};
if (isNil "_volume") exitWith {};

_volume = ((_volume min 1) max 0);

[_radio, "setVolume", _volume] call EFUNC(sys_data,dataEvent);
