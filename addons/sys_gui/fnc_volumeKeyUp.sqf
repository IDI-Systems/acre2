#include "script_component.hpp"
/*
 * Author: mharis001
 * Handles releasing the volume control key.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_gui_fnc_volumeKeyUp
 *
 * Public: No
 */

if (!GVAR(volumeOpen)) exitWith {false};

inGameUISetEventHandler ["PrevAction", "false"];
inGameUISetEventHandler ["NextAction", "false"];

VOLUME_CONTROL_LAYER cutText ["", "PLAIN"];

GVAR(volumeLevel) call FUNC(setVoiceCurveLevel);
GVAR(volumeOpen) = false;

false
