#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handler for the player disconnected event handler. Inputs match the playerDisconnect event, only required parameter is the owner ID.
 *
 * Arguments:
 * 0: Unique DirectPlay ID <NUMBER>
 * 1: Steam player ID <STRING>
 * 2: Profile name of leaving player <STRING>
 * 3: Did JIP <BOOLEAN>
 * 4: Owner ID of leaving client <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_server_fnc_handlePlayerDisconnected
 *
 * Public: No
 */

private _ownerId = param [4,-1];

private _idx = ACRE_SPECTATORS_A3_CLIENT_ID_LIST find _ownerId;
while {_idx != -1} do {
    ACRE_SPECTATORS_LIST deleteAt _idx;
    ACRE_SPECTATORS_A3_CLIENT_ID_LIST deleteAt _idx;
    _idx = ACRE_SPECTATORS_A3_CLIENT_ID_LIST find _ownerId;
};
publicVariable "ACRE_SPECTATORS_LIST";
