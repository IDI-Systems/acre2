/*
 * Author: ACRE2Team
 * Updates the open radio state.
 *
 * Arguments:
 * 0: radio to update <STRING>
 * 1: radio opened state <BOOL>
 * 2: client Id with opened radio <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1", false, 2] call acre_sys_server_fnc_openRadioUpdateState
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_radioIsOpened", "_clientId"];

private _radioOpenedBy = RADIO_IS_NOT_OPENED;

// Check first if the radio is opened by somebody else
call compile format ["_radioOpenedBy = %1", _radioId];

// If it does not exist or it has a value of -1, the value can be updated
if (isNil "_radioOpenedBy" || {_radioOpenedBy == RADIO_IS_NOT_OPENED} || {_radioOpenedBy == _clientId}) then {
    private _newState = RADIO_IS_NOT_OPENED;
    if (_radioIsOpened) then {
        _newState = _clientId;
    };
    call compile format ["%1 = %2", _radioId, _newState];
};
