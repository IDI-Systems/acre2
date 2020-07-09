#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles updating the given spectator display's radios list to
 * match the radios of the currently focused target.
 * Also handles updating the visibility of the speaking list.
 *
 * Arguments:
 * 0: Arguments <ARRAY>
 *   0: Display <DISPLAY>
 *   1: Target Function <CODE>
 *   2: Visible Function <CODE>
 *   3: Started Speaking ID <NUMBER>
 *   4: Stopped Speaking ID <NUMBER>
 * 2: PFH Handle <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_args, _pfhID] call acre_sys_spectator_fnc_handleUpdate
 *
 * Public: No
 */

params ["_args", "_pfhID"];
_args params ["_display", "_targetFunction", "_visibleFunction", "_startedSpeakingID", "_stoppedSpeakingID"];

// Exit if the spectator display is closed
if (isNull _display) exitWith {
    ["acre_remoteStartedSpeaking", _startedSpeakingID] call CBA_fnc_removeEventHandler;
    ["acre_remoteStoppedSpeaking", _stoppedSpeakingID] call CBA_fnc_removeEventHandler;

    [_pfhID] call CBA_fnc_removePerFrameHandler;
};

// Show/hide the speaking list control based on UI visibility
private _ctrlSpeaking = _display displayCtrl IDC_SPEAKING;
_ctrlSpeaking ctrlShow call _visibleFunction;

// Get the currently focused target
private _target = [] call _targetFunction;
if (isNull _target) exitWith {};

// Refresh the list with the target's radios
private _radios = _target call EFUNC(sys_data,getRemoteRadioList);

private _ctrlList = _display displayCtrl IDC_RADIOS_LIST;
lbClear _ctrlList;

{
    private _radioType = [_x] call EFUNC(sys_radio,getRadioBaseClassname);
    private _config = configFile >> "CfgWeapons" >> _radioType;
    private _name = getText (_config >> "displayName");
    private _icon = getText (_config >> "picture");
    private _channel = [_x, "getChannelDescription"] call EFUNC(sys_data,dataEvent);
    private _number = [_x] call EFUNC(sys_radio,getRadioIdNumber);

    private _index = _ctrlList lbAdd format ["%1 [%2]", _name, _number];
    _ctrlList lbSetData [_index, _x];
    _ctrlList lbSetTextRight [_index, _channel];
    _ctrlList lbSetPictureRight [_index, _icon];

    if (_x in ACRE_SPECTATOR_RADIOS) then {
        _ctrlList lbSetPicture [_index, ICON_CHECKED];
    } else {
        _ctrlList lbSetPicture [_index, ICON_UNCHECKED];
    };
} forEach _radios;

lbSort _ctrlList;

// Show none text if target has no radios
private _ctrlNone = _display displayCtrl IDC_RADIOS_NONE;
_ctrlNone ctrlShow (_radios isEqualTo []);
