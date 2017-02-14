/*
 * Author: ACRE2Team
 * Returns a list of radios that are being shared by a unit
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Array of ACRE2 unique radio IDs that are flagged as shared <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_sys_external_getSharedExternalRadios
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

private _radios = [_unit] call EFUNC(sys_core,getGear);
private _radioList = _radios select {_x call EFUNC(sys_radio,isUniqueRadio)};
private _sharedRadios = _radioList select {[_x, "getState", "isShared"] call EFUNC(sys_data,dataEvent)};

_sharedRadios;
