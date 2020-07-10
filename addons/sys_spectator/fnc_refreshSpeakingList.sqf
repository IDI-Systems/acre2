#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Refreshes the speaking list control based on the current spectator radio speakers.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY] call acre_sys_spectator_fnc_refreshSpeakingList
 *
 * Public: No
 */

params ["_display"];

private _entries = [];

// _key is the speaking unit and _value is the radio ID
[_display getVariable QGVAR(speakers), {
    private _radioType = [_value] call EFUNC(sys_radio,getRadioBaseClassname);
    private _icon = getText (configFile >> "CfgWeapons" >> _radioType >> "picture");
    private _channel = [_value, "getChannelDescription"] call EFUNC(sys_data,dataEvent);

    _entries pushBack format ["<t color='#BF9900'>%1</t> %2<img image='%3' />", name _key, _channel, _icon];
}] call CBA_fnc_hashEachPair;

private _ctrlSpeaking = _display displayCtrl IDC_SPEAKING;
_ctrlSpeaking ctrlSetStructuredText parseText (_entries joinString "<br />");
