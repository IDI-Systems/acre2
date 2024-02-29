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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_callEntryFunctor
 *
 * Public: No
 */

params ["_menu"];

TRACE_1("enter",_menu);

private _ret =  false;
if (!isNil "_menu" && {(count _menu) > 5}) then {
    private _events = MENU_ACTION_EVENTS(_menu);
    if (!isNil "_events" && {_events isEqualType []} && {_events isNotEqualTo []}) then {
        private _onEntryFunction = MENU_ACTION_ONENTRY(_menu);
        if (!isNil "_onEntryFunction") then {
            _ret = [_onEntryFunction, _menu] call FUNC(dynamicCall);
        };
    };
};

if (isNil "_ret") then { _ret = false; };
_ret
