#include "script_component.hpp"
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

params ["_class","_player"];
_class = toLower _class;

private _index = GVAR(unacknowledgedIds) find _class;
if (_index != -1) then {
    if (hasInterface && {isServer && {acre_player == _player}}) then {
        private _fnc = {
            _class = _this;
            GVAR(unacknowledgedIds) deleteAt (GVAR(unacknowledgedIds) find _class);
            HASH_REM(GVAR(unacknowledgedTable),_class);
        };
        [_fnc, _class] call CBA_fnc_execNextFrame;
    } else {
        GVAR(unacknowledgedIds) deleteAt _index;
        HASH_REM(GVAR(unacknowledgedTable),_class);
    };
} else {
    WARNING_2("%1 attempted to acknowledge ID %2 which was not awaiting acknowledgement",_player,_class);
};
