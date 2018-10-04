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
 * [ARGUMENTS] call acre_sys_server_fnc_addComponentCargo;
 *
 * Public: No
 */

params ["_container", "_type", ["_preset", "default"], ["_callBack", ""], ["_failCallBack", ""]];
[QGVAR(doAddComponentCargo), [_container, _type, _preset, acre_player, _callBack, _failCallBack]] call CALLSTACK(CBA_fnc_globalEvent);
