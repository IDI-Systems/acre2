/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_radio_allowExternalUse
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

private _radios = [_unit] call EFUNC(sys_core,getGear);
private _radioList = _radios select {_x call EFUNC(sys_radio,isUniqueRadio)};
private _sharedRadios = _radioList select {[_x, "getState", "isShared"] call EFUNC(sys_data,dataEvent)};

_sharedRadios;
