/*
 * Author: ACRE2Team
 * Sets the global volume of the output from ACRE. 1 is normal, 0 is silent
 *
 * Arguments:
 * 0: Volume between 0 and 1 <NUMBER>
 *
 * Return Value:
 * Volume <NUMBER>
 *
 * Example:
 * [0.05] call acre_api_fnc_setGlobalVolume;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_volume"];

_volume = ((_volume min 1) max 0);

acre_sys_core_globalVolume = _volume;

_volume
