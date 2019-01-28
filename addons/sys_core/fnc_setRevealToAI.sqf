/*
 * Author: ACRE2Team
 * Sets whether AI can detect players speaking. This is randomized against the range of the unit, and takes into account the duration and quantity of speaking. In a nutshell, the closer you are to an AI unit and the more you speak - the better chance he has of hearing you. Also takes into account the distance a player's voice will travel.
 * Effects are local.
 *
 * Arguments:
 * 0: Reveal factor players to AI that speak <NUMBER>
 *
 * Return Value:
 * Reveal factor for revealing players to AI <BOOL>
 *
 * Example:
 * _status = [0.5] call acre_sys_core_fnc_setRevealToAI
 *
 * Public: No
 */
#include "script_component.hpp"

if (!hasInterface) exitWith {false};

params ["_var"];

// Set
if !(_var isEqualType false) exitWith { false };

if (GVAR(revealToAI) isEqualTo 0 && _var > 0) then {
    [] call FUNC(enableRevealAI);
} else {
    if (GVAR(revealToAI) > 0 && _var isEqualTo 0) then {
        [] call FUNC(disableRevealAI);
    };
};

GVAR(revealToAI) = _var;

_var
