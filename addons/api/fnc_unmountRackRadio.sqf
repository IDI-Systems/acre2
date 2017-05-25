/*
 * Author: ACRE2Team
 * Removes a mounted radio. Must be executed on the server.
 *
 * Arguments:
 * 0: Rack ID <STRING> (default: "")
 * 1: Radio to unmount <STRING> (default: "")
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * ["ACRE_VRC103_ID_1", "ACRE_PRC117F_ID_1"] call acre_api_fnc_unmountRackRadio
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_rackId", ""], ["_radioId", ""]];

private _return = false;

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    _return
};

if (isDedicated) then {
    // Pick the first player
    private _player = (allPlayers - entities "HeadlessClient_F") select 0;
    [QGVAR(unmountRackRadio), [_rackId, _radioId], _player] call CBA_fnc_targetEvent;
} else {
    if (!([_rackId] call EFUNC(sys_radio,radioExists))) exitWith {
        WARNING_1("Non existant rack ID provided: %1",_rackId);
    };

    if (!([_radioId] call EFUNC(sys_radio,radioExists))) exitWith {
        WARNING_1("Non existant radio ID provided: %1",_radioId);
    };

    private _mountedRadio = [_rackId, "getState", "mountedRadio"] call EFUNC(sys_data,dataEvent);

    if (_mountedRadio != _radioId) exitWith {
        WARNING_3("Trying to dismount %1 from Rack ID %2. However, the mounted radio is %3.",_radioId,_rackId,_mountedRadio);
    };

    if (_mountedRadio == "") exitWith {
        WARNING_1("Attempting to unmount empty rack '%1'",_rackId);
    };

    if (_mountedRadio == "") exitWith {
        WARNING_1("Attempting to unmount empty rack '%1'",_rackId);
    };

    [_rackId, "setState", ["mountedRadio", ""]] call EFUNC(sys_data,dataEvent);
    [_rackId, _mountedRadio] call EFUNC(sys_components,detachAllConnectorsFromComponent);

    // Trigger event
    [_rackId, "unmountRadio", _mountedRadio] call EFUNC(sys_data,dataEvent);

    _return = true;
};

_return
