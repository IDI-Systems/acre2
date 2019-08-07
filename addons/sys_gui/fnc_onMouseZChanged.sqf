#include "script_component.hpp"
/*
 * Author: mharis001
 * Handles using the scroll wheel to change the volume level.
 *
 * Arguments:
 * 0: Display (not used) <DISPLAY>
 * 1: Scroll Amount <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY, 1.2] call acre_sys_gui_fnc_onMouseZChanged
 *
 * Public: No
 */

params ["", "_scroll"];

private _ctrlLevel = uiNamespace getVariable [QGVAR(volumeControl), controlNull];
if (isNull _ctrlLevel) exitWith {};

GVAR(volumeLevel) = progressPosition _ctrlLevel + _scroll / abs _scroll * VOLUME_LEVEL_CHANGE;
_ctrlLevel progressSetPosition GVAR(volumeLevel);

private _color = GVAR(volumeLevel) call FUNC(getVolumeColor);
_ctrlLevel ctrlSetTextColor _color;
