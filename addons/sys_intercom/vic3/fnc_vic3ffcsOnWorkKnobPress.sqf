#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles turning the work knob.
 *
 * Arguments:
 * 0: Unused
 * 1: Key direction. O: left, 1: right <NUMBER>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [idc, 0] call acre_sys_intercom_fnc_vic3ffcsOnWorkKnobPress
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
private _workPos = [_vehicle, acre_player, GVAR(activeIntercom), "workKnob"] call FUNC(getStationConfiguration);
private _newWorkPos = ((_workPos + _currentDirection) max 0) min 6;

if (_newWorkPos != _workPos) then {
    [_vehicle, acre_player, GVAR(activeIntercom), "workKnob", _newWorkPos] call FUNC(setStationConfiguration);

    private _wiredRacks = [_vehicle, acre_player, GVAR(activeIntercom), "wiredRacks"] call FUNC(getStationConfiguration);
    private _monitorPos = [_vehicle, acre_player, GVAR(activeIntercom), "monitorKnob"] call FUNC(getStationConfiguration);
    private _rackCount = count _wiredRacks;

    // Set the previous rack to no monitor unless it is selected in the monitor knob
    if ((_workPos - 1 != _monitorPos) && {_workPos < _rackCount} && {(_wiredRacks select _workPos) select 1 != RACK_DISABLED}) then {
        (_wiredRacks select _workPos) set [1, RACK_NO_MONITOR];
    };

    if ((_newWorkPos < _rackCount) && {(_wiredRacks select _newWorkPos) select 1 != RACK_DISABLED}) then {
        (_wiredRacks select _newWorkPos) set [1, RACK_RX_AND_TX];
    };

    [MAIN_DISPLAY] call FUNC(vic3ffcsRender);
};

