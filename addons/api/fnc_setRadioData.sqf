#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Set the internal state / de-serialize data of a radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Radio Data (Serialized) <ARRAY>
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
_data params ["_radioType", "_radioDataSerialized"];

private _baseRadio = [_radioId] call EFUNC(api,getBaseRadio);
if (_baseRadio == _radioType) then {
    private _radioData = _radioDataSerialized call EFUNC(sys_data,deserialize);
    HASH_SET(EGVAR(sys_data,radioData),_radioId,_radioData);
};
