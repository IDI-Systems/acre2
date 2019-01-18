#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles turning the monitor knob.
 *
 * Arguments:
 * 0: Unused
 * 1: Key direction. O: left, 1: right <NUMBER>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [idc, 0] call acre_sys_intercom_fnc_vic3ffcsOnMonitorKnobPress
 *
 * Public: No
 */

params ["", "_key"];

private _currentDirection = -0.1;
if (_key == 0) then {
    // left click
    _currentDirection = 0.1;
};

private _vehicle = vehicle acre_player;
private _currentVolume = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_VOLUME] call FUNC(getStationConfiguration);
private _newVolume = ((_currentVolume + _currentDirection) max 0) min 7;

if (_newVolume != _currentVolume) then {
    [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_VOLUME, _newVolume] call FUNC(setStationConfiguration);

    [MAIN_DISPLAY] call FUNC(vic3ffcsRender);
};

