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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_toggleIcon;
 *
 * Public: No
 */

params ["_iconId", "_toggle"];

private _ctrl = ((uiNamespace getVariable [QGVAR(currentDisplay), displayNull]) displayCtrl _iconId);
private _type = ctrlType _ctrl;

if ((count _this) > 2) then {
    private _newPosition = _this select 2;
    _ctrl ctrlSetPosition _toggle;
};

//if (_type == 8) then {
//    (_display displayCtrl _iconId) progressSetPosition 0.85;
//};

_ctrl ctrlShow _toggle;
_ctrl ctrlCommit 0;
