#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the channel number of the currently active channel on the provided radio ID.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Channel number <NUMBER>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = ["ACRE_PRC152_ID_123", 5] call acre_api_fnc_setRadioChannel;
 *
 * Public: Yes
 */

params [
    ["_radioId", "", [""]],
    ["_channelNumber", 0, [0]]
];

if !(_radioId isEqualType "") exitWith { false };

if (_channelNumber isEqualType 0) then {
    private _eventData = _channelNumber - 1;
    if (([_radioId] call FUNC(getBaseRadio)) == "ACRE_PRC77") then {
        _eventData = [_channelNumber, 0] // ACRE_PRC77 expects an array of [mhzKnob, khzKnob]
    };
    [_radioId, "setCurrentChannel", _eventData] call EFUNC(sys_data,dataEvent);
} else {
    // Should we handle a channel NAME and find it, and change it?!?

};

true
