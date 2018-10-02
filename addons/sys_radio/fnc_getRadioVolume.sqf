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
#include "script_component.hpp"

params ["_radio"];

if (isNil "_radio") exitWith {};

if (!([_radio] call EFUNC(sys_data,isRadioInitialized))) exitWith {};

private _volume = [_radio, "getVolume"] call EFUNC(sys_data,dataEvent);

_volume
