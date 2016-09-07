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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: Yes
 */
#include "script_component.hpp"

private["_presetPointer", "_return"];
params["_radioClass", "_preset", "_presetData"];

_return = false;

_presetPointer = [_radioClass,_preset] call EFUNC(sys_data,getPresetData);
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
