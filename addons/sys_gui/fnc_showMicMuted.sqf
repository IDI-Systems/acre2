#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Shows or hides the microphone muted icon.
 *
 * Arguments:
 * 0: Muted <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_sys_gui_fnc_showMicMuted
 *
 * Public: No
 */

params ["_muted"];

private _layer = QGVAR(micMuted) call BIS_fnc_rscLayer;
if (_muted) then {
    _layer cutRsc [QGVAR(micMuted), "PLAIN", 0, false];
} else {
    _layer cutText ["", "PLAIN"];
};
