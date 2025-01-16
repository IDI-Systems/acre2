#include "script_component.hpp"
/*
 * Author: Gerard
 * Gets the status (ON/OFF) for the given radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * TRUE if radio is ON, False if the radio is OFF <BOOLEAN>
 *
 * Example:
 * ["ACRE_PR77_ID_1"] call acre_api_fnc_getRadioOnOffState
 *
 * Public: Yes
 */

params ["_radioId"];

if (isNil "_radioId") exitWith { -1 };

if (!([_radioId] call EFUNC(sys_data,isRadioInitialized))) exitWith { -1 };

private _radioOnOffStatus = [_radioId] call EFUNC(sys_radio,getRadioOnOffState);

_radioOnOffStatus
