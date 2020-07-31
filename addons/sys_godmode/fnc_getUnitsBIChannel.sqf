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
    case 0: { _units = allPlayers; };    // Global
    case 1: {                            // Side
        private _side = side acre_player;
        _units = allPlayers select {(_side == (side _x)) && {(alive _x) || {[_x] call acre_api_fnc_isSpectator}}};
    };
    case 3: {                            // Group
        _units = (units group acre_player) select {(alive _x) || {[_x] call acre_api_fnc_isSpectator}};
    };
    case 4: {                            // Vehicle
        if ((vehicle acre_player) isEqualTo acre_player) then {
            _units = [];
        } else {
            _units = (units vehicle acre_player) select {(alive _x) || {[_x] call acre_api_fnc_isSpectator}};
        };
    };
    default {                            // Global, Command, Direct and Custom channels
        _units = allPlayers select {(alive _x) || {[_x] call acre_api_fnc_isSpectator}};
    };                   
};

// Remove local player
_units deleteAt (_units find acre_player);

_units
