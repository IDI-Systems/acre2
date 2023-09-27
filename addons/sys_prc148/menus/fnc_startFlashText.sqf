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
 * [ARGUMENTS] call acre_sys_prc148_fnc_startFlashText
 *
 * Public: No
 */

params ["_display", "_row", "_range"];

private _flashingText = SCRATCH_GET_DEF(GVAR(currentRadioId), "flashingText", []);
private _id = count _flashingText;
_flashingText set [_id, [_row, _range]];
SCRATCH_SET(GVAR(currentRadioId), "flashingText", _flashingText);
hintSilent format["GVAR(currentRadioId): %1", GVAR(currentRadioId)];
_id;
