#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles a unit broadcasting a message through all intercom stations.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit broadcasting <OBJECT>
 * 2: Intercom network <NUMBER>
 * 3: Is broadcasting <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(vehicle acre_player), acre_player, true] call acre_sys_intercom_fnc_handleBroadcasting
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_intercomNetwork", "_isBroadcasting"];

private _broadcastConfig = _vehicle getVariable [QGVAR(broadcasting), []];
GVAR(broadcastKey) = _isBroadcasting;

private _changes = false;
{
    private _canBroadcast = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_MASTERSTATION] call FUNC(getStationConfiguration);
    if ((_intercomNetwork == _forEachIndex || (_intercomNetwork == ALL_INTERCOMS)) && {_canBroadcast}) then {
        if (_isBroadcasting) then {
            _broadcastConfig set [_forEachIndex, [_isBroadcasting, _unit]];
        } else {
            _broadcastConfig set [_forEachIndex, [_isBroadcasting, objNull]];
        };
        _changes = true;
    };
} forEach (_vehicle getVariable [QGVAR(intercomNames), []]);

// Only broadcast if changes have been made.
// TODO: Remove synchronisation once intercom system has been converted to components and unique IDs.
//       It will help in reduce the bandwith, since information will be exchanged through the TS plugin.
if (_changes) then {
    [_vehicle, _unit] call FUNC(updateVehicleInfoText);
    _vehicle setVariable [QGVAR(broadcasting), _broadcastConfig, true];

    if (_isBroadcasting) then {
        ["startIntercomSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);
    } else {
        ["stopIntercomSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);
    };
};
