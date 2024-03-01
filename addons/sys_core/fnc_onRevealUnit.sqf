#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Helper function for revealing units to AI for non-local AI.
 *
 * Arguments:
 * 0: Player to reveal <OBJECT>
 * 1: Unit to reveal to <OBJECT>
 * 2: Reveal amount <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [player, unit, 4.0] call acre_sys_core_fnc_onRevealUnit
 *
 * Public: No
 */

params ["_player", "_unit", "_revealAmount"];

TRACE_1("onRevealUnit",_this);

if (!local _unit) exitWith {false};

_unit reveal [_player, _revealAmount];

true
