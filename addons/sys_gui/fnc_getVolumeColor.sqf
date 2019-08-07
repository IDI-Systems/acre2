#include "script_component.hpp"
/*
 * Author: mharis001
 * Returns the corresponding color to the given volume level.
 *
 * Arguments:
 * 0: Volume Level (0..1) <NUMBER>
 *
 * Return Value:
 * Color <ARRAY>
 *
 * Example:
 * [0.5] call acre_sys_gui_fnc_getVolumeColor
 *
 * Public: No
 */

params ["_level"];

VOLUME_COLOR_SCALE select (0 max ceil (count VOLUME_COLOR_SCALE * (_level min 1) - 1))
