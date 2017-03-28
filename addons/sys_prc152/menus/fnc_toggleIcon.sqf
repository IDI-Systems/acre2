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
 * [ARGUMENTS] call acre_sys_prc152_fnc_toggleIcon
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_iconId","_toggle"];

private _ctrl = ((uiNamespace getVariable [QGVAR(currentDisplay), displayNull]) displayCtrl _iconId);
private _type = ctrlType _ctrl;

if ((count _this) > 2) then {
    private _newPosition = _this select 2;
    _ctrl ctrlSetPosition _toggle;
};

if (_type isEqualTo 8) then {
    _ctrl progressSetPosition 0.5;
};

_ctrl ctrlShow _toggle;
_ctrl ctrlCommit 0;
