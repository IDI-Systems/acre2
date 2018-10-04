#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * An invalid garbage collect event occurs when a radio is being collected when it shouldn't.
 *
 * Arguments:
 * 0: player <OBJECT>
 * 1: Radio classname <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player,"acre_prc343_id_1"] call acre_sys_server_fnc_invalidGarbageCollect
 *
 * Public: No
 */

params ["_playerName", "_radioId"];

ERROR_2("Invalid garbage collection for radio '%1' from player %2! Please forward on the client and server RPTs to the ACRE2 bug tracker.",_radioId,_playerName);
