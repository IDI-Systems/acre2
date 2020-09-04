#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Hides a given notification layer.
 *
 * Arguments:
 * 0: Notification display ID <NUMBER>
 * 1: Notification pointer <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [46, 0] call acre_sys_list_fnc_hideHint
 *
 * Public: No
 */

params ["_hintIDD", "_bufferpointer"];

_hintIDD = findDisplay _hintIDD;

GVAR(hintBuffer) set [_bufferpointer, 0];

(_hintIDD displayCtrl (IDC_GROUP + _bufferpointer)) ctrlSetFade 1;
(_hintIDD displayCtrl (IDC_GROUP + _bufferpointer)) ctrlCommit 0.5;

[{
    params ["_hintIDD", "_bufferpointer"];

    ctrlDelete (_hintIDD displayCtrl (IDC_GROUP + _bufferpointer));
    ctrlDelete (_hintIDD displayCtrl (IDC_FLASH_GROUP + _bufferpointer));
}, [_hintIDD, _bufferpointer], 0.5] call CBA_fnc_waitAndExecute;
