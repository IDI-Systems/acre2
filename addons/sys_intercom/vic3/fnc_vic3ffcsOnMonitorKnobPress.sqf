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
private _newMonitorPos = ((_monitorPos + _currentDirection) max 0) min VIC3FFCS_MONITOR_KNOB_POSITIONS;

if (_newMonitorPos != _monitorPos) then {
    private _wiredRacks = [_vehicle, acre_player, GVAR(activeIntercom), "wiredRacks"] call FUNC(getStationConfiguration);
    private _workPos = [_vehicle, acre_player, GVAR(activeIntercom), "workKnob"] call FUNC(getStationConfiguration);
    private _rackCount = count _wiredRacks;

    // Set the previous rack to no monitor unless it is selected in the work knob
    if (_monitorPos == VIC3FFCS_MONITOR_KNOB_POSITIONS) then {
        {
            if (_forEachIndex != (_workPos - 1) && {_x select 1 != RACK_DISABLED}) then {
                private _rackId = _x select 0;
                private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

                _x set [1, RACK_NO_MONITOR];

                if (_radioId != "") then {
                    [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,stopUsingMountedRadio);
                };
            };
        } forEach _wiredRacks;
    } else {
        private _selectedRack = _wiredRacks select _monitorPos;
        if ((_monitorPos < _rackCount) && {(_workPos - 1) != _monitorPos} && {_selectedRack select 1 != RACK_DISABLED}) then {
            private _rackId = _selectedRack select 0;
            private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

            _selectedRack set [1, RACK_NO_MONITOR];

            if (_radioId != "") then {
                [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,stopUsingMountedRadio);
            };
        };
    };

    if (_newMonitorPos == VIC3FFCS_MONITOR_KNOB_POSITIONS) then {
        {
            if (_x select 1 != RACK_DISABLED) then {
                private _rackId = _x select 0;
                private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

                _x set [1, RACK_RX_ONLY];

                if (_radioId != "") then {
                    [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,startUsingMountedRadio);
                };
            };
        } forEach _wiredRacks;
    } else {
        private _selectedRack = _wiredRacks select _newMonitorPos;
        if ((_newMonitorPos < _rackCount) && {_selectedRack select 1 != RACK_DISABLED}) then {
            private _rackId = _selectedRack select 0;
            private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

            _selectedRack set [1, RACK_RX_ONLY];

            if (((_newMonitorPos - 1) != _workPos) && {_radioId != ""}) then {
                [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,startUsingMountedRadio);
            };
        };
    };

    [_vehicle, acre_player, GVAR(activeIntercom), "monitorKnob", _newMonitorPos] call FUNC(setStationConfiguration);
    [MAIN_DISPLAY] call FUNC(vic3ffcsRender);
};

