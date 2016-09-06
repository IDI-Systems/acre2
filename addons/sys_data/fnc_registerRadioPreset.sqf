/*
 * Author: AUTHOR
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
 * Public: No
 */
#include "script_component.hpp"

params ["_radioType", "_presetName", "_presetData"];
// diag_log text format["registering preset: %1", _this];
private _radioPresets = HASH_GET(GVAR(radioPresets),_radioType);
if(isNil "_radioPresets") then {
    _radioPresets = HASH_CREATE;
    HASH_SET(GVAR(radioPresets),_radioType,_radioPresets);
};
HASH_SET(_radioPresets,_presetName,_presetData);
