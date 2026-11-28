#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Marks players who muted their microphone in the Players screen (RscDisplayMPPlayers) while it
 * is open. The game fills and refreshes the list itself, so the marks are reapplied regularly.
 *
 * Arguments:
 * 0: Players display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call acre_sys_gui_fnc_playersDisplayLoad
 *
 * Public: No
 */

params ["_display"];

[{
    params ["_display", "_handle"];
    if (isNull _display) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    private _muted = allPlayers select {_x getVariable [QEGVAR(sys_core,micMuted), false]} apply {name _x};
    private _list = _display displayCtrl 101;
    for "_i" from 0 to (lbSize _list) - 1 do {
        private _text = _list lbText _i;
        // Rows are player names; allow for anything the game appends.
        private _isMuted = (_muted findIf {_text == _x || {(_text find (_x + " ")) == 0}}) != -1;
        if (_isMuted) then {
            _list lbSetPictureRight [_i, MIC_MUTED_ICON];
            _list lbSetPictureRightColor [_i, [1, 0.25, 0.25, 1]];
            _list lbSetPictureRightColorSelected [_i, [1, 0.25, 0.25, 1]];
            _list lbSetTooltip [_i, localize LSTRING(playerMicMuted)];
        } else {
            _list lbSetPictureRight [_i, ""];
            _list lbSetTooltip [_i, ""];
        };
    };
}, 0.25, _display] call CBA_fnc_addPerFrameHandler;
