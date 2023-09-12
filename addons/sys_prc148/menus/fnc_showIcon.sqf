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
 * [ARGUMENTS] call acre_sys_prc148_fnc_showIcon
 *
 * Public: No
 */

params ["_display", "_icon", "_show"];

private _ctrl = _display displayCtrl _icon;

_ctrl ctrlShow _show;
_ctrl ctrlCommit 0;
