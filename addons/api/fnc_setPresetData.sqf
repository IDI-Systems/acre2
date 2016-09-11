/*
 * Author: ACRE2Team
 * Sets the full data set to be utilized for the specified preset name. Improper data will most likely break ACRE on all clients. This function must be called on all clients and the server to work properly.
 *
 * Arguments:
 * 0: Radio base type <STRING>
 * 1: Preset name <STRING>
 * 2: Preset data <HASH>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = ["ACRE_PRC152", "new_preset", _presetData] call acre_api_fnc_setPresetData;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_radioClass", "_preset", "_presetData"];

private _return = false;

private _presetPointer = [_radioClass,_preset] call EFUNC(sys_data,getPresetData);
if(!isNil "_presetPointer") then {
    {
        if((_presetData select _forEachIndex) isEqualType []) then {
            _presetPointer set[_forEachIndex, +(_presetData select _forEachIndex)];
        } else {
            _presetPointer set[_forEachIndex, (_presetData select _forEachIndex)];
        };
    } forEach _presetData;
    _return = true;
};
true
