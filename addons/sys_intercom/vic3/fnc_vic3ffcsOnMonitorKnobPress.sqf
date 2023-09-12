#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles turning the monitor knob.
 *
 * Arguments:
 * 0: IDC <NUMBER> (unused)
 * 1: Key direction. O: left, 1: right <NUMBER>
 *
 * Return Value:
 * None
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
private _monitorPos = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_MONITORKNOB] call FUNC(getStationConfiguration);
private _newMonitorPos = ((_monitorPos + _currentDirection) max 0) min VIC3FFCS_MONITOR_KNOB_POSITIONS;

if (_newMonitorPos == _monitorPos) exitWith {};

private _wiredRacks = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_WIREDRACKS] call FUNC(getStationConfiguration);
private _workPos = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_WORKKNOB] call FUNC(getStationConfiguration);

// Set the previous rack to no monitor unless it is selected in the work knob
if (_monitorPos == VIC3FFCS_MONITOR_KNOB_POSITIONS) then {
    {
        private _rackId = _x select 0;
        if ((_rackId != "") && {(_forEachIndex + 1) != _workPos} && {_x select 2}) then {
            private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

            _x set [1, RACK_NO_MONITOR];

            if (_radioId != "") then {
                [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,stopUsingMountedRadio);
            };
        };
    } forEach _wiredRacks;
} else {
    if (_monitorPos != 0) then {
        private _selectedRack = _wiredRacks select (_monitorPos - 1); // RackID, Functionality, Has Access
        private _rackId = _selectedRack select 0;
        if (_rackId != "" && {_workPos != _monitorPos} && {_selectedRack select 2}) then {
            private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

            _selectedRack set [1, RACK_NO_MONITOR];

            if (_radioId != "") then {
                [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,stopUsingMountedRadio);
            };
        };
    };
};

if (_newMonitorPos == VIC3FFCS_MONITOR_KNOB_POSITIONS) then {
    {
        private _rackId = _x select 0;
        if (_rackId != "" && {_x select 2} && ((_workPos != _forEachIndex + 1))) then {
            private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

            _x set [1, RACK_RX_ONLY];

            if (_radioId != "") then {
                [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,startUsingMountedRadio);
            };
        };
    } forEach _wiredRacks;
} else {
    if (_newMonitorPos != 0) then {
        private _selectedRack = _wiredRacks select (_newMonitorPos - 1);  // RackID, Functionality, Has Access
        private _rackId = _selectedRack select 0;
        if (_rackId != "" && {_selectedRack select 2}) then {
            _rackId = _selectedRack select 0;
            private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

            if ((_newMonitorPos != _workPos) && {_radioId != ""}) then {
                _selectedRack set [1, RACK_RX_ONLY];
                [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,startUsingMountedRadio);
            };
        };
    };
};

[_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_MONITORKNOB, _newMonitorPos] call FUNC(setStationConfiguration);
[MAIN_DISPLAY, _vehicle] call FUNC(vic3ffcsRender);
