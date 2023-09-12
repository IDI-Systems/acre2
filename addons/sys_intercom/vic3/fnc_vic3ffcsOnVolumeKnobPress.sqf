#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles turning the volume knob.
 *
 * Arguments:
 * 0: 0: IDC <NUMBER> (unused)
 * 1: Key direction. O: left, 1: right <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [idc, 0] call acre_sys_intercom_fnc_vic3ffcsOnVolumeKnobPress
 *
 * Public: No
 */

params ["", "_key"];

private _currentDirection = -0.125;
if (_key == 0) then {
    // Left click
    _currentDirection = 0.125;
};

private _vehicle = vehicle acre_player;
private _currentVolume = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_VOLUME] call FUNC(getStationConfiguration);
private _newVolume = ((_currentVolume + _currentDirection) max 0) min 1.25;

if (_newVolume != _currentVolume) then {
    [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_VOLUME, _newVolume] call FUNC(setStationConfiguration);
    [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_VOLUMEKNOB, _newVolume*100/12.5] call FUNC(setStationConfiguration);
    [MAIN_DISPLAY, _vehicle] call FUNC(vic3ffcsRender);
};

