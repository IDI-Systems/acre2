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

private _currentDirection = -1;
if (_key == 0) then {
    // Left click
    _currentDirection = 1;
};

private _vehicle = vehicle acre_player;
private _monitorPos = [_vehicle, acre_player, GVAR(activeIntercom), "monitorKnob"] call FUNC(getStationConfiguration);
private _newMonitorPos = ((_monitorPos + _currentDirection) max 0) min 7;

if (_newMonitorPos != _monitorPos) then {
    [_vehicle, acre_player, GVAR(activeIntercom), "monitorKnob", _newMonitorPos] call FUNC(setStationConfiguration);

    private _wiredRacks = [_vehicle, acre_player, GVAR(activeIntercom), "wiredRacks"] call FUNC(getStationConfiguration);
    private _workPos = [_vehicle, acre_player, GVAR(activeIntercom), "workKnob"] call FUNC(getStationConfiguration);
    private _rackCount = count _wiredRacks;

    // Set the previous rack to no monitor unless it is selected in the work knob
    if (_workPos -1 != _monitorPos && {_monitorPos < _rackCount} && {(_wiredRacks select _monitorPos) select 1 != RACK_DISABLED}) then {
        (_wiredRacks select _monitorPos) set [1, RACK_NO_MONITOR];
    };

    if ((_newMonitorPos < _rackCount) && {(_wiredRacks select _newMonitorPos) select 1 != RACK_DISABLED}) then {
        (_wiredRacks select _newMonitorPos) set [1, RACK_RX_ONLY];
    };

    [MAIN_DISPLAY] call FUNC(vic3ffcsRender);
};

