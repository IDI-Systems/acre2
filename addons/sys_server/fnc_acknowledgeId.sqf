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
#include "script_component.hpp"

params ["_class","_player"];

if ((GVAR(unacknowledgedIds) find _class) != -1) then {
    if (!isDedicated) then {
        if (isServer && acre_player == _player) then {
            private _fnc = {
                _class = _this;
                GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_class];
            };
            [_fnc, _class] call CBA_fnc_execNextFrame;
        };
    } else {
        GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_class];
    };
} else {
    WARNING_2("%1 attempted to acknowledge ID %2 which was not awaiting acknowledgement",_player,_class);
};
