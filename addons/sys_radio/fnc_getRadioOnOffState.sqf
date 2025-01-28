#include "script_component.hpp"
/*
 * Author: Gerard
 * Returns the status (ON/OFF) for the given radio.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 *
 * Return Value:
 * TRUE if radio is ON, False if the radio is OFF <BOOLEAN>
 *
 * Example:
 * ["ACRE_PR77_ID_1"] call acre_sys_radio_fnc_getRadioOnOffState
 *
 * Public: No
 */

params ["_radio"];

private _onOffState = [_radio, "getOnOffState"] call EFUNC(sys_data,dataEvent);

_onOffState
