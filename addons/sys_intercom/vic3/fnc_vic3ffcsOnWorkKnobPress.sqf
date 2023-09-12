#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles turning the work knob.
 *
 * Arguments:
 * 0: 0: IDC <NUMBER> (unused)
 * 1: Key direction. O: left, 1: right <NUMBER>
 *
 * Return Value:
 * None
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
private _workPos = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_WORKKNOB] call FUNC(getStationConfiguration);
private _newWorkPos = ((_workPos + _currentDirection) max 0) min VIC3FFCS_WORK_KNOB_POSITIONS;

if (_newWorkPos == _workPos) exitWith {};

private _wiredRacks = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_WIREDRACKS] call FUNC(getStationConfiguration);
private _monitorPos = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_MONITORKNOB] call FUNC(getStationConfiguration);

// Set the previous rack to no monitor unless it is selected in the monitor knob
if (_workPos != 0) then {
    private _selectedRack = _wiredRacks select (_workPos - 1);

    private _rackId = _selectedRack select 0;
    if (_rackId != "" && {_selectedRack select 2}) then {
        if (_workPos != _monitorPos) then {
            private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

            if (_monitorPos != VIC3FFCS_MONITOR_KNOB_POSITIONS) then {
                _selectedRack set [1, RACK_NO_MONITOR];
                if (_radioId != "") then {
                    [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,stopUsingMountedRadio);
                };
            } else {
                _selectedRack set [1, RACK_RX_ONLY];
            };
        } else {
            _selectedRack set [1, RACK_RX_ONLY];
        };
    };
};

if (_newWorkPos != 0) then {
    private _selectedRack = _wiredRacks select (_newWorkPos - 1); // RackID, Functionality, Has Access
    private _rackId = _selectedRack select 0;
    if ((_rackId != "") && {_selectedRack select 2}) then {
        private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);
        _selectedRack set [1, RACK_RX_AND_TX];

        if ((_newWorkPos != _monitorPos) && {_radioId != ""}) then {
            [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,startUsingMountedRadio);
        };
    };
} else {
    private _selectedRack = _wiredRacks select (_workPos - 1);
    private _rackId = _selectedRack select 0;
    if ((_rackId != "") && {_selectedRack select 2} && {_workPos != _monitorPos} && {_monitorPos != VIC3FFCS_MONITOR_KNOB_POSITIONS} ) then {
        private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

        _selectedRack set [1, RACK_NO_MONITOR];
        if (_radioId != "") then {
            [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,stopUsingMountedRadio);
        };
    };
};

[_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_WORKKNOB, _newWorkPos] call FUNC(setStationConfiguration);
[MAIN_DISPLAY, _vehicle] call FUNC(vic3ffcsRender);
