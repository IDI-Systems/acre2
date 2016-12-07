/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_player"];

if (!("ACRE_TestGearDesyncItem" in (items _player))) then {
    ["acre_handleDesyncCheck", [_player, true]] call CALLSTACK(CBA_fnc_globalEvent);
} else {
    ["acre_handleDesyncCheck", [_player, false]] call CALLSTACK(CBA_fnc_globalEvent);
};
