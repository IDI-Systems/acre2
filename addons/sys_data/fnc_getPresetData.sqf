#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_getPresetData
 *
 * Public: No
 */

params ["_radioType", "_presetName"];

// diag_log text format["getting preset data for: %1", _this];
private _radioPresets = HASH_GET(GVAR(radioPresets),_radioType);

if (isNil "_radioPresets") exitWith {nil};

HASH_GET(_radioPresets,_presetName)
