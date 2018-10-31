#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if a radio is a manpack radio.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 *
 * Return Value:
 * Is manpack radio <BOOL>
 *
 * Example:
 * [1] call acre_sys_core_fnc_switchChannelFast
 *
 * Public: No
 */

params ["_radioId"];

private _radioType = [_radioId] call EFUNC(sys_radio,getRadioBaseClassname);
(getNumber (configFile >> "CfgAcreComponents" >> _radioType >> "isPackRadio")) == 1
