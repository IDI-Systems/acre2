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
        if (!isNil "_events" && _events isEqualType [] && count _events > 3) then {
            private _onRenderFunction = MENU_ACTION_ONRENDER(_menu);
            if (!isNil "_onRenderFunction") then {
                _ret = [_onRenderFunction, _menu] call FUNC(dynamicCall);
            };
        };
    };
};

if (isNil "_ret") then { _ret = false; };

_ret
