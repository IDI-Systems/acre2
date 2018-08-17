/*
 * Author: ACRE2Team
 * Sets whether AI can detect players speaking. This is randomized against the range of the unit, and takes into account the duration and quantity of speaking. In a nutshell, the closer you are to an AI unit and the more you speak - the better chance he has of hearing you. Also takes into account the distance a player's voice will travel.
 * Effects are local.
 *
 * Arguments:
 * 0: Reveal players to AI that speak <BOOL>
 *
 * Return Value:
 * Are players that speak revealed to AI <BOOL>
 *
 * Example:
 * _status = [false] call acre_sys_core_fnc_setRevealToAI
 *
 * Public: No
 */
#include "script_component.hpp"

if (!hasInterface) exitWith {false};

params ["_var"];

// Set
if !(_var isEqualType false) exitWith { false };

if (!EGVAR(sys_core,revealToAI) && _var) then {
    [] call FUNC(,enableRevealAI);
} else {
    if (EGVAR(sys_core,revealToAI) && !_var) then {
        [] call FUNC(disableRevealAI);
    };
};

GVAR(revealToAI) = _var;

_var
