#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Get the internal state / serialized data of a radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Serialized Radio Data <ARRAY>
 *
 * Example:
 * ["ACRE_PRC148_ID_1"] call acre_api_fnc_getRadioData;
 *
 * Public: Yes
 */

params ["_radioId"];

private _baseRadio = [_radioId] call EFUNC(api,getBaseRadio);
private _radioDataSerialized = HASH_GET(EGVAR(sys_data,radioData),_radioId) call EFUNC(sys_data,serialize);
[_baseRadio, _radioDataSerialized]
