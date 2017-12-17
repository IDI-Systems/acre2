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
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomNetwork", "_isBroadcasting"];

private _broadcastConfig = _vehicle getVariable [QGVAR(broadcasting), []];

{
    if (_intercomNetwork == _forEachIndex || (_intercomNetwork == ALL_INTERCOMS)) then {
        if (_isBroadcasting) then {
            _broadcastConfig set [_forEachIndex, [_isBroadcasting, _unit]];
        } else {
            _broadcastConfig set [_forEachIndex, [_isBroadcasting, objNull]];
        };
    };
} forEach (_vehicle getVariable [QGVAR(intercomNames), []]);

_vehicle setVariable [QGVAR(broadcasting), _broadcastConfig, true];
