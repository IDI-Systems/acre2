#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles turning the intercom knob.
 *
 * Arguments:
 * 0: IDC <NUMBER> (unused)
 * 1: Key direction. O: left, 1: right <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [idc, 0] call acre_sys_intercom_fnc_vic3ffcsOnIntercomKnobPress
 *
 * Public: No
 */

params ["", "_key"];

private _currentDirection = -1;
if (_key == 0) then {
    // Left click
    _currentDirection = 1;
};

private _vehicle = vehicle acre_player;
private _intercomPos = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_INTERCOMKNOB] call FUNC(getStationConfiguration);
private _newIntercomPos = ((_intercomPos + _currentDirection) max 0) min 3;

if (_newIntercomPos != _intercomPos) then {

    // Broadcasting only in position O/R (Override)
    if (_intercomPos == 3) then {
        [_vehicle, acre_player, GVAR(activeIntercom), false] call FUNC(handleBroadcasting);
    };

    private _voiceActivation = false;
    if ((_newIntercomPos == 1) || {_newIntercomPos == 2}) then {
        _voiceActivation = true;
    } else {
        if (_newIntercomPos == 3) then {
            [_vehicle, acre_player, GVAR(activeIntercom), true] call FUNC(handleBroadcasting);
        };
    };

    [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_VOICEACTIVATION, _voiceActivation] call FUNC(setStationConfiguration);
    [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_INTERCOMKNOB, _newIntercomPos] call FUNC(setStationConfiguration);

    [MAIN_DISPLAY, _vehicle] call FUNC(vic3ffcsRender);
};
