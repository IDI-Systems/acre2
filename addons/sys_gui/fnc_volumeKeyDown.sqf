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

if (!alive acre_player || ACRE_IS_SPECTATOR || GVAR(volumeOpen)) exitWith {false};

// Abort on open Dialogs that aren't an ACE Progressbar
private _aceProgressBar = displayNull;
if (
    dialog && 
    {
        !EGVAR(sys_core,aceLoaded) || 
        {_aceProgressBar = (uiNamespace getVariable ["ace_common_dlgProgress", displayNull]); _aceProgressBar isEqualTo displayNull}
    }
) exitWith {false};

// Add MouseScroll EH to open ACE Progressbar, for volume control
if (dialog && {!(_aceProgressBar getVariable [QGVAR(mouseScrollEHAdded), false])}) then {
    _aceProgressBar displayAddEventHandler ["MouseZChanged", LINKFUNC(onMouseZChanged)];
    _aceProgressBar setVariable [QGVAR(mouseScrollEHAdded), true];
};

inGameUISetEventHandler ["PrevAction", "true"];
inGameUISetEventHandler ["NextAction", "true"];

VOLUME_CONTROL_LAYER cutRsc [QGVAR(VolumeControl), "PLAIN"];

private _ctrlLevel = uiNamespace getVariable [QGVAR(volumeControl), controlNull];
_ctrlLevel progressSetPosition GVAR(volumeLevel);

private _color = GVAR(volumeLevel) call FUNC(getVolumeColor);
_ctrlLevel ctrlSetTextColor _color;

GVAR(volumeOpen) = true;

false
