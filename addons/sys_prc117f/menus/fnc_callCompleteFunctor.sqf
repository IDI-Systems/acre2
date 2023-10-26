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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_callCompleteFunctor
 *
 * Public: No
 */

params ["_menu"];

private _ret =  false;
if (!isNil "_menu" && {(count _menu) > 5}) then {
    private _events = MENU_ACTION_EVENTS(_menu);
    if (!isNil "_events" && {_events isEqualType []} && {count _events > 1}) then {
        private _onCompleteFunction = MENU_ACTION_ONCOMPLETE(_menu);
        if (!isNil "_onCompleteFunction") then {
            _ret = [_onCompleteFunction, _menu] call FUNC(dynamicCall);
        };
    };
};

if (isNil "_ret") then { _ret = false; };
_ret
