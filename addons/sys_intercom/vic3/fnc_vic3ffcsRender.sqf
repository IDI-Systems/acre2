#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Renders the VIC3 FFCS when opened.
 *
 * Arguments:
 * 0: Display identifier <NUMBER>
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * [DisplayID] call acre_sys_intercom_fnc_vic3ffcsRender
 *
 * Public: No
 */

#define INTERCOM_CTRL(var1) (_display displayCtrl var1)
params ["_display", ["_vehicle", objNull]];

if (isNull _vehicle) then {_vehicle = vehicle acre_player};

private _intercomKnobPosition = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_INTERCOMKNOB] call FUNC(getStationConfiguration);
private _monitorKnobPosition = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_MONITORKNOB] call FUNC(getStationConfiguration);
private _volumeKnobPosition = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_VOLUMEKNOB] call FUNC(getStationConfiguration);
private _workKnobPosition = [_vehicle, acre_player, GVAR(activeIntercom), INTERCOM_STATIONSTATUS_WORKKNOB] call FUNC(getStationConfiguration);

// Intercom
private _intercomImages = [
    QPATHTOF(vic3\data\knobs\intercom\intercom_0.paa),
    QPATHTOF(vic3\data\knobs\intercom\intercom_1.paa),
    QPATHTOF(vic3\data\knobs\intercom\intercom_2.paa),
    QPATHTOF(vic3\data\knobs\intercom\intercom_3.paa)
];

// Monitor
private _monitor = [
    QPATHTOF(vic3\data\knobs\monitor\monitor_0.paa),
    QPATHTOF(vic3\data\knobs\monitor\monitor_1.paa),
    QPATHTOF(vic3\data\knobs\monitor\monitor_2.paa),
    QPATHTOF(vic3\data\knobs\monitor\monitor_3.paa),
    QPATHTOF(vic3\data\knobs\monitor\monitor_4.paa),
    QPATHTOF(vic3\data\knobs\monitor\monitor_5.paa),
    QPATHTOF(vic3\data\knobs\monitor\monitor_6.paa),
    QPATHTOF(vic3\data\knobs\monitor\monitor_7.paa)
];

// Volume
private _volumeImages = [
    QPATHTOF(vic3\data\knobs\volume\volume_0.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_1.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_2.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_3.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_4.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_5.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_6.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_7.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_8.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_9.paa),
    QPATHTOF(vic3\data\knobs\volume\volume_10.paa)
];

// Work
private _workImages = [
    QPATHTOF(vic3\data\knobs\work\work_0.paa),
    QPATHTOF(vic3\data\knobs\work\work_1.paa),
    QPATHTOF(vic3\data\knobs\work\work_2.paa),
    QPATHTOF(vic3\data\knobs\work\work_3.paa),
    QPATHTOF(vic3\data\knobs\work\work_4.paa),
    QPATHTOF(vic3\data\knobs\work\work_5.paa),
    QPATHTOF(vic3\data\knobs\work\work_6.paa)
];

INTERCOM_CTRL(101) ctrlSetText (_intercomImages select _intercomKnobPosition);
INTERCOM_CTRL(102) ctrlSetText (_monitor select _monitorKnobPosition);
INTERCOM_CTRL(103) ctrlSetText (_volumeImages select _volumeKnobPosition);
INTERCOM_CTRL(104) ctrlSetText (_workImages select _workKnobPosition);

true
