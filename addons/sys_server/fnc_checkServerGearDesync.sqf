/*
 * Author: ACRE2Team
 * Handles the gear desync test on the server.
 *
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player] call acre_sys_server_fnc_checkServerGearDesync
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
