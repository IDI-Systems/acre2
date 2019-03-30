#include "script_component.hpp"
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
params ["_display", "_vehicle"];
systemChat format ["Render: %1", _display];
private _intercomKnobPosition = [_vehicle, acre_player, GVAR(activeIntercom), "intercomKnob"] call FUNC(getStationConfiguration);
private _monitorKnobPosition = [_vehicle, acre_player, GVAR(activeIntercom), "monitorKnob"] call FUNC(getStationConfiguration);
private _volumeKnobPosition = [_vehicle, acre_player, GVAR(activeIntercom), "volumeKnob"] call FUNC(getStationConfiguration);
private _workKnobPosition = [_vehicle, acre_player, GVAR(activeIntercom), "workKnob"] call FUNC(getStationConfiguration);

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

INTERCOM_CTRL(201) ctrlSetText (_intercomImages select 2);//_intercomKnobPosition);
INTERCOM_CTRL(202) ctrlSetText (_monitor select 3);//_monitorKnobPosition);
INTERCOM_CTRL(203) ctrlSetText (_volumeImages select 7);//_volumeKnobPosition);
INTERCOM_CTRL(204) ctrlSetText (_workImages select 1);//_workKnobPosition);

true
