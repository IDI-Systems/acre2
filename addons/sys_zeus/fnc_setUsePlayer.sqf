#include "script_component.hpp"
/*
 * Author: Brett Mayson
 * Set if the player speaks through their unit or the remote controlled unit.
 *
 * Arguments:
 * 0: Speak through player (true) or remote controlled unit (false) <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_sys_zeus_fnc_setUsePlayer
 *
 * Public: No
 */

params ["_usePlayer"];

private _isTalking = ACRE_LOCAL_SPEAKING;

[] call EFUNC(sys_core,localStopSpeaking);

acre_player = if (_usePlayer) then { player } else { acre_current_player };
// save the last used value for this unit
acre_player setVariable [QGVAR(usePlayer), _usePlayer];

if (_isTalking) then {
    [] call EFUNC(sys_core,localStartSpeaking);
};
