#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets whether AI can detect players speaking. This is randomized against the range of the unit, and takes into account the duration and quantity of speaking. In a nutshell, the closer you are to an AI unit and the more you speak - the better chance he has of hearing you. Also takes into account the distance a player's voice will travel.
 * Effects are local.
 *
 * Arguments:
 * 0: Reveal factor players to AI that speak <NUMBER>
 *
 * Return Value:
 * Reveal factor for revealing players to AI <NUMBER>
 *
 * Example:
 * _status = [0.5] call acre_sys_core_fnc_setRevealToAI
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params [
    ["_var", 0, [0]]
];

if (_var == GVAR(revealToAI) && {GVAR(monitorAIHandle) != -1}) exitWith {_var};

GVAR(revealToAI) == _var;

if ((GVAR(revealToAI) > 0) && {GVAR(monitorAIHandle) == -1}) then {
    GVAR(monitorAIHandle) = ADDPFH(DFUNC(monitorAiPFH), 0.5, []);
    INFO("AI Detection Activated.");
};

if (GVAR(revealToAI) == 0) then {
    [GVAR(monitorAIHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(monitorAIHandle) = -1;
    INFO("AI Detection Not Active.");
};

_var
