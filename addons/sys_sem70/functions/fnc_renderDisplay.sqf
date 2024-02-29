#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem70_fnc_renderDisplay
 *
 * Public: No
 */

#define RADIO_CTRL(var1) (_display displayCtrl var1)

params ["_display"];
 {
    RADIO_CTRL(_x) ctrlSetText "";
} forEach [301,302,303,304,305/*,109*/]; // purge.

//private _channelKnobPosition = GET_STATE("channelKnobPosition");
private _mainKnobPosition = GET_STATE("mainKnobPosition");
private _functionKnobPosition = GET_STATE("functionKnobPosition");
private _manualChannelSelection = GET_STATE("manualChannelSelection");


//if (_channelKnobPosition == 0) exitWith {}; // OFF

private _firstDigit = [
    QPATHTOF(data\display\1char_0.paa),
    QPATHTOF(data\display\1char_1.paa),
    QPATHTOF(data\display\1char_2.paa),
    QPATHTOF(data\display\1char_3.paa),
    QPATHTOF(data\display\1char_4.paa),
    QPATHTOF(data\display\1char_5.paa),
    QPATHTOF(data\display\1char_6.paa),
    QPATHTOF(data\display\1char_7.paa),
    QPATHTOF(data\display\1char_8.paa),
    QPATHTOF(data\display\1char_9.paa)
];

private _secondDigit = [
    QPATHTOF(data\display\2char_0.paa),
    QPATHTOF(data\display\2char_1.paa),
    QPATHTOF(data\display\2char_2.paa),
    QPATHTOF(data\display\2char_3.paa),
    QPATHTOF(data\display\2char_4.paa),
    QPATHTOF(data\display\2char_5.paa),
    QPATHTOF(data\display\2char_6.paa),
    QPATHTOF(data\display\2char_7.paa),
    QPATHTOF(data\display\2char_8.paa),
    QPATHTOF(data\display\2char_9.paa)
];

private _thirdDigit = [
    QPATHTOF(data\display\3char_0.paa),
    QPATHTOF(data\display\3char_1.paa),
    QPATHTOF(data\display\3char_2.paa),
    QPATHTOF(data\display\3char_3.paa),
    QPATHTOF(data\display\3char_4.paa),
    QPATHTOF(data\display\3char_5.paa),
    QPATHTOF(data\display\3char_6.paa),
    QPATHTOF(data\display\3char_7.paa),
    QPATHTOF(data\display\3char_8.paa),
    QPATHTOF(data\display\3char_9.paa)
];

private _fourthDigit = [
    QPATHTOF(data\display\4char_0.paa),
    QPATHTOF(data\display\4char_1.paa),
    QPATHTOF(data\display\4char_2.paa),
    QPATHTOF(data\display\4char_3.paa),
    QPATHTOF(data\display\4char_4.paa),
    QPATHTOF(data\display\4char_5.paa),
    QPATHTOF(data\display\4char_6.paa),
    QPATHTOF(data\display\4char_7.paa),
    QPATHTOF(data\display\4char_8.paa),
    QPATHTOF(data\display\4char_9.paa)
];

private _fifthDigit = [
    QPATHTOF(data\display\5char_0.paa),
    QPATHTOF(data\display\5char_1.paa),
    QPATHTOF(data\display\5char_2.paa),
    QPATHTOF(data\display\5char_3.paa),
    QPATHTOF(data\display\5char_4.paa),
    QPATHTOF(data\display\5char_5.paa),
    QPATHTOF(data\display\5char_6.paa),
    QPATHTOF(data\display\5char_7.paa),
    QPATHTOF(data\display\5char_8.paa),
    QPATHTOF(data\display\5char_9.paa)
];

private _dotDisplay = QPATHTOF(data\display\dot.paa);

private _currentChannel = GET_STATE("currentChannel");
private _channels = GET_STATE("channels");
private _channel = _channels select _currentChannel;

// Can't use CBA_fnc_formatNumber due to precision error - This will simply format a number into usable array.
private _fnc_formatNumber = {
    params ["_in"];
    private _numbers = [];

    _numbers = [floor ((_in mod 100)/10), floor (_in mod 10)];

    _in = round ((_in - (floor _in)) * 1000); // bypass floating point issues
    _numbers + [floor ((_in mod 1000)/100),floor ((_in mod 100)/10), floor (_in mod 10)];
};

if (_manualChannelSelection == 1) then {
    private _kHzKnobPosition = GET_STATE("kHzKnobPosition");
    private _MHzKnobPosition = GET_STATE("MHzKnobPosition");

    private _freq = HASH_GET(_channel,"frequencyRX");
    private _numbers = [_freq] call _fnc_formatNumber;

    TRACE_1("Frequency Number",_numbers);

    RADIO_CTRL(301) ctrlSetText (_firstDigit param [_numbers param [0,0]]);
    RADIO_CTRL(302) ctrlSetText (_secondDigit param [_numbers param [1,0]]);
    RADIO_CTRL(303) ctrlSetText (_thirdDigit param [_numbers param [2,0]]);
    RADIO_CTRL(304) ctrlSetText (_fourthDigit param [_numbers param [3,0]]);
    RADIO_CTRL(305) ctrlSetText (_fifthDigit param [_numbers param [4,0]]);
} else {
    private _networkKnobPosition = ["getState", "NetworkKnobPosition"] call GUI_DATA_EVENT;

    RADIO_CTRL(301) ctrlSetText (_firstDigit param [_currentChannel param [0,0]]);
    RADIO_CTRL(302) ctrlSetText (_thirdDigit param [_networkKnobPosition param [0,0]]);
    RADIO_CTRL(303) ctrlSetText _dotDisplay; // Yeah, swapped with the other dialog due to layer order
    RADIO_CTRL(304) ctrlSetText (_fourthDigit param [_networkKnobPosition param [1,0]]);
    RADIO_CTRL(305) ctrlSetText (_fifthDigit param [_networkKnobPosition param [2,0]]);
};
