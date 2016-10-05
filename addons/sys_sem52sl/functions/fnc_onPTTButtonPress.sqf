/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params["_display"];

private _knobPosition = ["getState", "channelKnobPosition"] call GUI_DATA_EVENT;

GVAR(depressedPTT) = true;
[{
    GVAR(depressedPTT) = false;
    [MAIN_DISPLAY] call FUNC(render);
}, GVAR(currentRadioId), 0.3] call CBA_fnc_waitAndExecute;

if (_knobPosition == 15) then { //programming mode
    private _step = ["getState", "programmingStep"] call GUI_DATA_EVENT;
    switch (_step) do {
        case 0: {
            [GVAR(currentRadioId), "setState", ["programmingStep",1]] call EFUNC(sys_data,dataEvent);
            private _channels = GET_STATE("channels");
            private _channel = _channels select GVAR(selectedChannel);
            private _freq = HASH_GET(_channel,"frequencyRX");
            GVAR(selectionDir) = 0;
            if (_freq < 70) then {
                GVAR(newFrequency) = _freq;
            } else {
                GVAR(newFrequency) = 46;
            };
        };
        case 1: {
            [GVAR(currentRadioId), "setState", ["programmingStep",2]] call EFUNC(sys_data,dataEvent);
            GVAR(selectionDir) = 0;
        };
        case 2: {
            // SAVE.
            private _channels = GET_STATE("channels");
            private _channel = _channels select GVAR(selectedChannel);
            HASH_SET(_channel,"frequencyRX",GVAR(newFrequency));
            HASH_SET(_channel,"frequencyTX",GVAR(newFrequency));
            ["setChannelData", [GVAR(selectedChannel), _channel]] call GUI_DATA_EVENT;

            [GVAR(currentRadioId), "setState", ["programmingStep",0]] call EFUNC(sys_data,dataEvent);
            GVAR(selectionDir) = 0;
        };

    };
};

[MAIN_DISPLAY] call FUNC(render);
