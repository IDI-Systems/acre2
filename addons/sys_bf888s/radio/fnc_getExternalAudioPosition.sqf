#include "script_component.hpp"
/*
 * Author: ACRE2Team
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "getExternalAudioPosition" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Array of zeros <ARRAY>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "getExternalAudioPosition", [], _radioData, false] call acre_sys_bf888s_fnc_getExternalAudioPosition
 *
 * Public: No
 */

params ["_radioId", "", "", ""];

private _obj = [_radioId] call EFUNC(sys_radio,getRadioObject);
private _pos = getPosASL _obj;
if (_obj isKindOf "Man") then {
    _pos = AGLtoASL (_obj modelToWorld (_obj selectionPosition "RightShoulder"));
};

_pos
