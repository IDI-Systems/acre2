#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Set the internal state of a radio
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Radio Data <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * private _data = ["ACRE_PRC148_ID_1"] call acre_api_fnc_getRadioData;
 * ["ACRE_PRC148_ID_2", _data] call acre_api_fnc_setRadioData;
 *
 * Public: Yes
 */

params ["_radioId", "_data"];
_data params ["_radioType", "_radioData"];

private _baseRadio = [_radioId] call EFUNC(api,getBaseRadio);
if (_baseRadio isEqualTo _radioType) then {
    HASH_SET(EGVAR(sys_data,radioData), _radioId, _radioData call EFUNC(sys_data,deserialize));
};
