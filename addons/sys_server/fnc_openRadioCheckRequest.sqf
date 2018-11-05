#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the request of a client checking if a radio is opened.
 *
 * Arguments:
 * 0: Radio to check <STRING>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1", acre_player] call acre_sys_server_fnc_openRadioCheckRequest
 *
 * Public: No
 */

params ["_radioId", "_unit"];

// Check first if the radio is opened by somebody else
private _radioOpenedBy = HASH_GET(GVAR(radioOpenedBy),_radioId);

if (isNull _radioOpenedBy) then {
    _radioOpenedBy = _unit;
};

[QGVAR(openRadioCheckResult), [_radioId, _radioOpenedBy], _unit] call CBA_fnc_targetEvent;
