/*
 * Author: AUTHOR
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

params["_class","_player"];

if((GVAR(unacknowledgedIds) find _class) != -1) then {
    if(!isDedicated) then {
        if(isServer && acre_player == _player) then {
            private _fnc = {
                _class = _this;
                GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_class];
            };
            [_fnc, _class] call EFUNC(sys_core,delayFrame);
        };
    } else {
        GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_class];
    };
} else {
    diag_log text format["%1 ACRE ERROR: %2 attempted to acknowledge ID %3 which was not awaiting acknowledgement!", diag_tickTime, _player, _class];
};
