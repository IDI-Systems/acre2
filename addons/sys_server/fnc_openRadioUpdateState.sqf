#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Updates the open radio state.
 *
 * Arguments:
 * 0: Radio to update <STRING>
 * 1: Radio opened state <BOOL>
 * 2: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1", false, acre_player] call acre_sys_server_fnc_openRadioUpdateState
 *
 * Public: No
 */

params ["_radioId", "_radioIsOpened", "_unit"];

// Check first if the radio is opened by somebody else
private _radioOpenedBy = missionNamespace getVariable [_radioId, objNull];

// If it does not exist or it has a value of -1, the value can be updated
if (isNull _radioOpenedBy || {_radioOpenedBy == _unit}) then {
    private _newState = objNull;
    if (_radioIsOpened) then {
        _newState = _unit;
    };
    HASH_SET(GVAR(radioOpenedBy),_radioId,_newState);
};
