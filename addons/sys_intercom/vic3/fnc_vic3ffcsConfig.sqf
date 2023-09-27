#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Configures the VIC-3 FFCS station.
 *
 * Arguments:
 * 0: Intercom Hash <ARRAY>
 * 1: Intercom configuration <ARRAY>
 *  0: Intercom volume <NUMBER>
 *  1: Monitoring rack <NUMBER>
 *  2: Actively used rack <NUMBER>
 *  3: Voice activation <BOOL>
 * 2: Vehicle <OBJECT>
 *
 * Return Value:
 * Intercom status Hash <ARRAY>
 *
 * Example:
 * [[] call CBA_fnc_hashCreate, [0.9, 1, 0, true], vehicle acre_player] call acre_sys_intercom_fnc_vic3ffcsConfig
 *
 * Public: No
 */

params ["_intercomStatus", "_configOptions", "_vehicle"];
_configOptions params ["_volume", "_monitoringRack", "_workRack", "_voiceActivation"];

if ((_volume < 0) || {_volume > 1.0}) then {
    ERROR_1("Intercom volume out of range for vehicle %1",_vehicle);
    _volume = 1.0;
};

if (_monitoringRack isEqualType "") then {
    if (_monitoringRack == "all") then {
        _monitoringRack = VIC3FFCS_MONITOR_KNOB_POSITIONS;
    } else {
        ERROR_1("Invalid monitoring rack string %1",_monitoringRack);
    };
};

if ((_monitoringRack < 0) || {_monitoringRack > VIC3FFCS_MONITOR_KNOB_POSITIONS}) then {
    ERROR_1("Monitor rack entry out of range for %1",_vehicle);
    _monitoringRack = VIC3FFCS_MONITOR_KNOB_POSITIONS;
};

if ((_workRack < 0) || {_workRack > VIC3FFCS_WORK_KNOB_POSITIONS}) then {
    ERROR_1("Work rack entry out of range for %1",_vehicle);
    _workRack = 0;
};

// Intercom
if (_voiceActivation) then {
    [_intercomStatus, INTERCOM_STATIONSTATUS_INTERCOMKNOB, 1] call CBA_fnc_hashSet;
} else {
    [_intercomStatus, INTERCOM_STATIONSTATUS_INTERCOMKNOB, 0] call CBA_fnc_hashSet;
};
[_intercomStatus, INTERCOM_STATIONSTATUS_VOICEACTIVATION, _voiceActivation] call CBA_fnc_hashSet;

// Monitor
[_intercomStatus, INTERCOM_STATIONSTATUS_MONITORKNOB, _monitoringRack] call CBA_fnc_hashSet;

// Volume
[_intercomStatus, INTERCOM_STATIONSTATUS_VOLUME, INTERCOM_DEFAULT_VOLUME] call CBA_fnc_hashSet;
[_intercomStatus, INTERCOM_STATIONSTATUS_VOLUMEKNOB, INTERCOM_DEFAULT_VOLUME*100/12.5] call CBA_fnc_hashSet;

// Work
[_intercomStatus, INTERCOM_STATIONSTATUS_WORKKNOB, _workRack] call CBA_fnc_hashSet;

// Racks
private _racks = [];
for "_i" from 0 to VIC3FFCS_WORK_KNOB_POSITIONS do {
    _racks pushBack ["", RACK_NO_MONITOR, false];
};
[_intercomStatus, INTERCOM_STATIONSTATUS_WIREDRACKS, _racks] call CBA_fnc_hashSet;

_intercomStatus
