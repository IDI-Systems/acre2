#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handler for recieving pong messages from the VOIP plugin. This is called periodically as it provides a
 * simple check to make sure VOIP is still connected to the game.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_pong
 *
 * Public: No
 */

// diag_log text format["PONG!!!!!!!!!!!!!!"];
EGVAR(sys_io,pongTime) = diag_tickTime;
