#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc152_fnc_getExternalAudioPosition
 *
 * Public: No
 */

params ["_radioId", "", "", ""];

private _obj = [_radioId] call EFUNC(sys_radio,getRadioObject);
private _pos = getPosASL _obj;
if (_obj isKindOf "Man") then {
    _pos = AGLtoASL (_obj modelToWorld (_obj selectionPosition "RightShoulder"));
};

_pos;
