#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the radio volume.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 *
 * Return Value:
 * Radio volume <NUMBER>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_getRadioVolume
 *
 * Public: No
 */

params ["_radio"];

private _volume = [_radio, "getVolume"] call EFUNC(sys_data,dataEvent);

_volume
