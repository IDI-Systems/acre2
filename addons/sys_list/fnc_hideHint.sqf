#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Hides a given notification item.
 *
 * Arguments:
 * 0: Unique prefixed ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["tag_x"] call acre_sys_list_fnc_hideHint
 *
 * Public: No
 */

params ["_id"];

private _bufferPointer = GVAR(hintBuffer) findIf {
    (_x isNotEqualTo []) && {_x select 0 == _id}
};
if (_bufferPointer == -1) exitWith {};

TRACE_3("hide",_id,_bufferPointer,GVAR(hintBuffer));
private _displayId = (GVAR(hintBuffer) select _bufferPointer) select 1;
GVAR(hintBuffer) set [_bufferPointer, []];

private _display = uiNamespace getVariable [QGVAR(hintDisplayOverride), displayNull];
if (_displayId != -1) then {
    _display = findDisplay _displayId;
};

if (!isNull _display) then {
    (_display displayCtrl (IDC_GROUP + _bufferPointer)) ctrlSetFade 1;
    (_display displayCtrl (IDC_GROUP + _bufferPointer)) ctrlCommit 0.5;
};
