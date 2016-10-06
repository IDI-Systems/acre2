/*
 * Author: ACRE2Team
 * Sets whether AI can detect players speaking. This is randomized against the range of the unit, and takes into account the duration and quantity of speaking. In a nutshell, the closer you are to an AI unit and the more you speak - the better chance he has of hearing you. Also takes into account the distance a player's voice will travel.
 * Effects are local.
 *
 * Arguments:
 * 0: Reveal players to AI that speak <BOOLEAN>
 *
 * Return Value:
 * Are players that speak revealed to AI <BOOLEAN>
 *
 * Example:
 * _status = [false] call acre_api_fnc_setRevealToAI
 *
 * Public: Yes
 */
#include "script_component.hpp"

INFO_2("%1 called with: %2",QFUNC(setRevealToAI),_this);

params ["_var"];

if (!hasInterface) exitWith {false};

//if(!isServer) exitWith {
//    WARNING_1("%1 called on client! Function is server-side only!",QFUNC(setRevealToAI));
//};

if(!(_var isEqualType false)) exitWith { false };


if( !ACRE_AI_ENABLED && _var ) then {
    [] call acre_sys_core_fnc_enableRevealAI;
} else {
    if( ACRE_AI_ENABLED && !_var ) then {
        [] call acre_sys_core_fnc_disableRevealAI;
    };
};

ACRE_AI_ENABLED = _var;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",ACRE_INTERFERENCE,ACRE_FULL_DUPLEX,EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),ACRE_AI_ENABLED);

_var
