/*
 * Author: SynixeBrett
 * set if the player speaks through their player or the remote controlled player
 *
 * Arguments:
 * 0: true to speak through player, false for remote controlled <BOOLEAN>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [true] call acre_sys_zeus_fnc_setUsePlayer;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_usePlayer"];

private _isTalking = ACRE_LOCAL_SPEAKING;

[] call EFUNC(sys_core,localStopSpeaking);

acre_player = if (_usePlayer) then { player } else { acre_current_player };
// save the last used value for this unit
acre_player setVariable [QGVAR(usePlayer), _usePlayer];

if (_isTalking) then {
    [] call EFUNC(sys_core,localStartSpeaking);
};
