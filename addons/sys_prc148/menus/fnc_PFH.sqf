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
 * [ARGUMENTS] call acre_sys_prc148_fnc_PFH
 *
 * Public: No
 */

private _display = uiNamespace getVariable QGVAR(currentDisplay);
private _flashingText = SCRATCH_GET_DEF(GVAR(currentRadioId), "flashingText", []);
private _flashingState = SCRATCH_GET_DEF(GVAR(currentRadioId), "flashingTextState", false);
private _color = [0, 0, 0, 1];
if (_flashingState) then {
    _color = [123/255, 179/255, 118/255, 1];
};

{
    _x params ["_row", "_range"];

    for "_i" from (_range select 0) to (_range select 1) do {
        private _textCtrl = _display displayCtrl (_row+_i);
        _textCtrl ctrlSetTextColor _color;
        _textCtrl ctrlCommit 0;
    };

} forEach _flashingText;
SCRATCH_SET(GVAR(currentRadioId), "flashingTextState", !_flashingState);

private _animations = SCRATCH_GET_DEF(GVAR(currentRadioId), "animations", []);

{
    [(_x select 0), (_x select 1)] call (_x select 2);
} forEach _animations;
