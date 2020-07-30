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
 * [] call acre_sys_godMode_fnc_getUnitsBIChannel
 *
 * Public: No
 */

private _units = [];

switch (currentChannel) do {
    case 0: { _units = allPlayers; };                                     // Global
    case 1: {                                                             // Side
        private _side = side acre_player;
        _units = allPlayers select {(_side == (side _x)) && {alive _x}};
    };
    case 3: { _units = (units group acre_player) select {alive _x}; };    // Group
    case 4: { _units = (units vehicle acre_player) select {alive _x}; };  // Vehicle
    default { _units = allPlayers select {alive _x}; };                   // Global, Command, Direct and Custom channels
};

// Remove local player
_units deleteAt (_units find acre_player);

_units
