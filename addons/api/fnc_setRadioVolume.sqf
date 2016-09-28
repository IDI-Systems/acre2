/*
 * Author: ACRE2Team
 * Set the radio volume for the specified radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Volume between 0 and 1 <NUMBER>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC343_ID_1",0.5] call acre_api_fnc_setRadioVolume;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_radioId","_volume"];

_volume = ((_volume min 1) max 0);

[_radioId, _volume] call EFUNC(sys_radio,setRadioVolume);

true
