#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds a procedure for when a message is received from the teamspeak plugin. Note only one callback exists before procedure this will override any previously setup callbacks for the specified procedure name.
 *
 * Arguments:
 * 0: Procedure name <STRING>
 * 1: Callback code <CODE>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["localStopSpeaking", {systemChat "localStopSpeaking";}] call acre_sys_rpc_fnc_addProcedure
 *
 * Public: No
 */

params ["_procedureName", "_procedureCodeBlock"];
HASH_SET(GVAR(procedures), _procedureName, _procedureCodeBlock);
