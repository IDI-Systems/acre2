#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initializes ACRE spectator radios handling for the ACE Spectator display.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY] call acre_sys_spectator_fnc_spectatorACEDisplayLoad
 *
 * Public: No
 */

params ["_display"];

// Resize focus info group to make space for radios control
private _ctrlFocusInfo = _display displayCtrl IDC_ACE_WIDGET;
_ctrlFocusInfo ctrlSetPositionY POS_Y(21);
_ctrlFocusInfo ctrlSetPositionH POS_H(7.1);
_ctrlFocusInfo ctrlCommit 0;

// Create radios control and adjust width to match focus info
private _ctrlRadios = _display ctrlCreate [QGVAR(RscRadios), IDC_RADIOS_GROUP, _ctrlFocusInfo];
_ctrlRadios ctrlSetPositionW POS_W(14.2);
_ctrlRadios ctrlCommit 0;

// Adjust width of other controls
{
    private _ctrl = _display displayCtrl _x;
    _ctrl ctrlSetPositionW POS_W(14.2);
    _ctrl ctrlCommit 0;
} forEach [IDC_RADIOS_BACKGROUND, IDC_RADIOS_NONE, IDC_RADIOS_LIST];

// Create speaking list control
_display ctrlCreate [QGVAR(RscSpeaking), IDC_SPEAKING];

[
    _display,
    {missionNamespace getVariable ["ace_spectator_camFocus", objNull]},
    {missionNamespace getVariable ["ace_spectator_uiVisible", true]}
] call FUNC(initDisplay);
