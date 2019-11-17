#include "script_component.hpp"
/*
 * Author: mharis001
 * Handles pressing the volume control key.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_gui_fnc_volumeKeyDown
 *
 * Public: No
 */

if (!alive acre_player || dialog || ACRE_IS_SPECTATOR || GVAR(volumeOpen)) exitWith {false};

inGameUISetEventHandler ["PrevAction", "true"];
inGameUISetEventHandler ["NextAction", "true"];

VOLUME_CONTROL_LAYER cutRsc [QGVAR(VolumeControl), "PLAIN"];

private _ctrlLevel = uiNamespace getVariable [QGVAR(volumeControl), controlNull];
_ctrlLevel progressSetPosition GVAR(volumeLevel);

private _color = GVAR(volumeLevel) call FUNC(getVolumeColor);
_ctrlLevel ctrlSetTextColor _color;

GVAR(volumeOpen) = true;

false
