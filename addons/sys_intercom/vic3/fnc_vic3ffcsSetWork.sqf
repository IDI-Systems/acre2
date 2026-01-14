#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the Work knob in the FFCS.
 *
 * Arguments:
 * 0: Intercom network <NUMBER>
 * 1: Work knob position <NUMBER>
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [0, 1] call acre_sys_intercom_fnc_vic3ffcsSetWork
 *
 * Public: No
 */

params ["_intercomNetwork", "_newWorkPos"];

if (_newWorkPos < 0 || _newWorkPos > VIC3FFCS_WORK_KNOB_POSITIONS) exitWith {false};

private _vehicle = vehicle acre_player;
private _workPos = [_vehicle, acre_player, _intercomNetwork, INTERCOM_STATIONSTATUS_WORKKNOB] call FUNC(getStationConfiguration);

if (_newWorkPos isEqualTo _workPos) exitWith {false};

private _wiredRacks = [_vehicle, acre_player, _intercomNetwork, INTERCOM_STATIONSTATUS_WIREDRACKS] call FUNC(getStationConfiguration);
private _monitorPos = [_vehicle, acre_player, _intercomNetwork, INTERCOM_STATIONSTATUS_MONITORKNOB] call FUNC(getStationConfiguration);

// Set the previous rack to no monitor unless it is selected in the monitor knob
if (_workPos isNotEqualTo 0) then {
    private _selectedRack = _wiredRacks select (_workPos - 1);

    private _rackId = _selectedRack select 0;
    if (_rackId isNotEqualTo "" && {_selectedRack select 2}) then {
        if (_workPos isNotEqualTo _monitorPos) then {
            private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

            if (_monitorPos isNotEqualTo VIC3FFCS_MONITOR_KNOB_POSITIONS) then {
                _selectedRack set [1, RACK_NO_MONITOR];
                if (_radioId isNotEqualTo "") then {
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

if (_newWorkPos isNotEqualTo 0) then {
    private _selectedRack = _wiredRacks select (_newWorkPos - 1); // RackID, Functionality, Has Access
    private _rackId = _selectedRack select 0;
    if ((_rackId isNotEqualTo "") && {_selectedRack select 2}) then {
        private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);
        _selectedRack set [1, RACK_RX_AND_TX];

        if ((_newWorkPos isNotEqualTo _monitorPos) && {_radioId isNotEqualTo ""}) then {
            [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,startUsingMountedRadio);
        };
    };
} else {
    private _selectedRack = _wiredRacks select (_workPos - 1);
    private _rackId = _selectedRack select 0;
    if ((_rackId isNotEqualTo "") && {_selectedRack select 2} && {_workPos isNotEqualTo _monitorPos} && {_monitorPos isNotEqualTo VIC3FFCS_MONITOR_KNOB_POSITIONS} ) then {
        private _radioId = [_rackId] call EFUNC(sys_rack,getMountedRadio);

        _selectedRack set [1, RACK_NO_MONITOR];
        if (_radioId isNotEqualTo "") then {
            [_vehicle, acre_player, _radioId] call EFUNC(sys_rack,stopUsingMountedRadio);
        };
    };
};

[_vehicle, acre_player, _intercomNetwork, INTERCOM_STATIONSTATUS_WORKKNOB, _newWorkPos] call FUNC(setStationConfiguration);

true
