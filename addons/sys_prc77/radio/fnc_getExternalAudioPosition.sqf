/*
 * Author: ACRE2Team
 * Only used if a radio has an internal speaker. Since the AN/PRC 77 has none, this function returns an
 * array of zeros and does nothing.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getExternalAudioPosition" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Array of zeros <ARRAY>
 *
 * Example:
 * ["ACRE_PRC77_ID_1", "getExternalAudioPosition", [], _radioData, false] call acre_sys_prc77_fnc_getExternalAudioPosition
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_event", "_eventData", "_radioData"];

private _obj = [_radioId] call EFUNC(sys_radio,getRadioObject);
private _pos = getPosASL _obj;

private _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
if (_rackId isEqualTo "") then {
    _pos = [0,0,0];
} else {
    private _vehicle = [_radioId] call EFUNC(sys_rack,getVehicleFromRack);
    private _position = [_rackId, _vehicle] call EFUNC(sys_rack,getRackPosition);
    if !(_position isEqualTo [0, 0, 0]) then {
        _pos = ATLtoASL (_vehicle modelToWorld _position);
    };
};

_pos
