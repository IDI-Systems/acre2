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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

private ["_ret"];
params ["_menu"];

TRACE_1("enter", _menu);

if (!isNil "_menu") then {
    if ((count _menu) > 5) then {
        private _events = MENU_ACTION_EVENTS(_menu);
        if (!isNil "_events") then {
            if (_events isEqualType []) then {
                if (count _events > 0) then {
                    private _onEntryFunction = MENU_ACTION_ONENTRY(_menu);
                    if (!isNil "_onEntryFunction") then {
                        _ret = [_onEntryFunction, _menu] call FUNC(dynamicCall);
                    };
                };
            };
        };
    };
};
if (isNil "_ret") then { _ret = false; };
_ret
