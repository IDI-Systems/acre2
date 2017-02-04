/*
 * Author: ACRE2Team
 * Acknowledges that a radio of with the ID has been created.
 *
 * Arguments:
 * 0: Radio class name <STRING>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc343_id_1", acre_player] call acre_sys_server_fnc_acknowledgeId
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_class","_player"];
_class = toLower _class;

if ((GVAR(unacknowledgedIds) find _class) != -1) then {
    if (hasInterface && {isServer && {acre_player == _player}}) then {
        private _fnc = {
            _class = _this;
            GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_class];
            HASH_REM(GVAR(unacknowledgedTable), _class);
        };
        [_fnc, _class] call CBA_fnc_execNextFrame;
    } else {
        GVAR(unacknowledgedIds) = GVAR(unacknowledgedIds) - [_class];
        HASH_REM(GVAR(unacknowledgedTable), _class);
    };
} else {
    WARNING_2("%1 attempted to acknowledge ID %2 which was not awaiting acknowledgement",_player,_class);
};
