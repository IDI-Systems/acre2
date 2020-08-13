#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Get the alive player units matching the current channel. If global chat, all units are targeted.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_godmode_fnc_getUnitsBIChannel
 *
 * Public: No
 */

private _units = allPlayers select {!(_x isKindOf "HeadlessClient_F")};

switch (currentChannel) do {
    case 1: { // Side
        private _side = side player;
        _units = _units select {(_side == (side _x)) || {_x in ACRE_SPECTATORS_LIST}};
    };
    case 3: { // Group
        _units = units (group player);
    };
    case 4: { // Vehicle
        if ((vehicle player) isEqualTo player) then {
            _units = [];
        } else {
            _units = [vehicle player] call EFUNC(sys_core,getPlayersInVehicle);
        };
    };
    default {}; // Global (0), Command, Direct and Custom channels (not supported, they all acts global
};

// Remove local player
_units deleteAt (_units find player);

_units
