/*
 * Author: ACRE2Team
 * Handles the request of a client checking if a radio is opened.
 *
 * Arguments:
 * 0: radio to check <STRING>
 * 1: Client ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1", 1] call acre_sys_server_fnc_openRadioCheckRequest
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_clientId"];

private "_radioOpenedBy";
call compile format ["_radioOpenedBy = %1", _radioId];

// A -1 is also returned if the radio is not opened by anybody
if (isNil "_radioOpenedBy" || {_radioOpenedBy == RADIO_IS_NOT_OPENED}) then {
    _radioOpenedBy = clientId;
};

[QGVAR(openRadioCheckResult), [_radioId, _radioOpenedBy], _clientId] call CBA_fnc_ownerEvent;
