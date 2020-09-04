#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Hides a given notification layer.
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
    !(_x isEqualTo []) && {_x select 0 == _id}
};

// Early exit if another control overwrote this one (spam pressing)
/*private _preventCleanup = GVAR(hintPreventCleanupCounters) select _bufferPointer;
if (_preventCleanup > 0) exitWith {
    GVAR(hintPreventCleanupCounters) set [_bufferPointer, (_preventCleanup - 1) max 0];
};*/

TRACE_3("hide",_id,_bufferPointer,GVAR(hintBuffer));
if (_bufferPointer == -1) exitWith {};

private _displayID = (GVAR(hintBuffer) select _bufferPointer) select 1;
GVAR(hintBuffer) set [_bufferPointer, []];

private _display = findDisplay _displayID;
if (isNull _display) exitWith {};

(_display displayCtrl (IDC_GROUP + _bufferPointer)) ctrlSetFade 1;
(_display displayCtrl (IDC_GROUP + _bufferPointer)) ctrlCommit 0.5;

[{
    params ["_display", "_bufferPointer"];

    // Race condition check if another control overwrote this one while fading out
    private _preventCleanup = GVAR(hintPreventCleanupCounters) select _bufferPointer;
    GVAR(hintPreventCleanupCounters) set [_bufferPointer, (_preventCleanup - 1) max -1];
    TRACE_1("cleanup counters",GVAR(hintPreventCleanupCounters));

    if (_preventCleanup <= 0) then {
        ctrlDelete (_display displayCtrl (IDC_GROUP + _bufferPointer));
        ctrlDelete (_display displayCtrl (IDC_FLASH_GROUP + _bufferPointer));
    };
}, [_display, _bufferPointer], 0.5] call CBA_fnc_waitAndExecute;
