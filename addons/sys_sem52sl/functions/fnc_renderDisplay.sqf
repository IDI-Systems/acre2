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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_renderDisplay
 *
 * Public: No
 */

#define RADIO_CTRL(var1) (_display displayCtrl var1)

params ["_display"];

{
    RADIO_CTRL(_x) ctrlSetText "";
} forEach [301, 302, 303, 304, 305, 109]; // purge.

private _channelKnobPosition = GET_STATE("channelKnobPosition");

if (_channelKnobPosition == 0) exitWith {}; // OFF

private _firstDigit = [
    QPATHTOF(data\display\1char_0.paa),
    QPATHTOF(data\display\1char_4.paa),
    QPATHTOF(data\display\1char_5.paa),
    QPATHTOF(data\display\1char_6.paa),
    QPATHTOF(data\display\1char_8.paa)
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
    QPATHTOF(data\display\4char_9.paa),
    QPATHTOF(data\display\4char_H.paa)
];

private _fifthDigit = [
    QPATHTOF(data\display\5char_0.paa),
    QPATHTOF(data\display\5char_2.paa),
    QPATHTOF(data\display\5char_5.paa),
    QPATHTOF(data\display\5char_6.paa),
    QPATHTOF(data\display\5char_8.paa)
];

private _complete = [
    QPATHTOF(data\display\display_blank.paa),
    QPATHTOF(data\display\noFr.paa),
    QPATHTOF(data\display\preset_xx.paa),
    QPATHTOF(data\display\preset_1x.paa)
]; //Also a preset_1x.paa

// Force  backlight
if (GVAR(backlightOn)) then {
    //backlight underneath.
    RADIO_CTRL(109) ctrlSetText QPATHTOF(data\display\backlight\display_blank.paa);
    // Overwrite
     _firstDigit = [
        QPATHTOF(data\display\backlight\1char_0.paa),
        QPATHTOF(data\display\backlight\1char_4.paa),
        QPATHTOF(data\display\backlight\1char_5.paa),
        QPATHTOF(data\display\backlight\1char_6.paa),
        QPATHTOF(data\display\backlight\1char_8.paa)
    ];

    _secondDigit = [
        QPATHTOF(data\display\backlight\2char_0.paa),
        QPATHTOF(data\display\backlight\2char_1.paa),
        QPATHTOF(data\display\backlight\2char_2.paa),
        QPATHTOF(data\display\backlight\2char_3.paa),
        QPATHTOF(data\display\backlight\2char_4.paa),
        QPATHTOF(data\display\backlight\2char_5.paa),
        QPATHTOF(data\display\backlight\2char_6.paa),
        QPATHTOF(data\display\backlight\2char_7.paa),
        QPATHTOF(data\display\backlight\2char_8.paa),
        QPATHTOF(data\display\backlight\2char_9.paa)
    ];

    _thirdDigit = [
        QPATHTOF(data\display\backlight\3char_0.paa),
        QPATHTOF(data\display\backlight\3char_1.paa),
        QPATHTOF(data\display\backlight\3char_2.paa),
        QPATHTOF(data\display\backlight\3char_3.paa),
        QPATHTOF(data\display\backlight\3char_4.paa),
        QPATHTOF(data\display\backlight\3char_5.paa),
        QPATHTOF(data\display\backlight\3char_6.paa),
        QPATHTOF(data\display\backlight\3char_7.paa),
        QPATHTOF(data\display\backlight\3char_8.paa),
        QPATHTOF(data\display\backlight\3char_9.paa)
    ];

    _fourthDigit = [
        QPATHTOF(data\display\backlight\4char_0.paa),
        QPATHTOF(data\display\backlight\4char_1.paa),
        QPATHTOF(data\display\backlight\4char_2.paa),
        QPATHTOF(data\display\backlight\4char_3.paa),
        QPATHTOF(data\display\backlight\4char_4.paa),
        QPATHTOF(data\display\backlight\4char_5.paa),
        QPATHTOF(data\display\backlight\4char_6.paa),
        QPATHTOF(data\display\backlight\4char_7.paa),
        QPATHTOF(data\display\backlight\4char_8.paa),
        QPATHTOF(data\display\backlight\4char_9.paa),
        QPATHTOF(data\display\backlight\4char_H.paa)
    ];

    _fifthDigit = [
        QPATHTOF(data\display\backlight\5char_0.paa),
        QPATHTOF(data\display\backlight\5char_2.paa),
        QPATHTOF(data\display\backlight\5char_5.paa),
        QPATHTOF(data\display\backlight\5char_6.paa),
        QPATHTOF(data\display\backlight\5char_8.paa)
    ];

    _complete = [
        QPATHTOF(data\display\backlight\display_blank.paa),
        QPATHTOF(data\display\backlight\noFr.paa),
        QPATHTOF(data\display\backlight\preset_xx.paa),
        QPATHTOF(data\display\backlight\preset_1x.paa)
    ];
};

// display 88.88888 if booting
if (GVAR(booting)) exitWith {
    RADIO_CTRL(301) ctrlSetText (_firstDigit select 4);
    RADIO_CTRL(302) ctrlSetText (_secondDigit select 8);
    RADIO_CTRL(303) ctrlSetText (_thirdDigit select 8);
    RADIO_CTRL(304) ctrlSetText (_fourthDigit select 8);
    RADIO_CTRL(305) ctrlSetText (_fifthDigit select 4);
};



private _channelKnobPosition = GET_STATE("channelKnobPosition");
private _isOn = GET_STATE("radioOn");

// Can't use CBA_fnc_formatNumber due to precision error - This will simply format a number into usable array.
private _fnc_formatNumber = {
    params ["_in"];
    private _numbers = [];

    _numbers = [floor ((_in mod 100)/10), floor (_in mod 10)];

    _in = round ((_in - (floor _in)) * 1000); // bypass floating point issues
    _numbers + [floor ((_in mod 1000)/100),floor ((_in mod 100)/10), floor (_in mod 10)];
};



switch _channelKnobPosition do {
        case 1: { // ON
            private _currentChannel = GET_STATE("currentChannel"); // add 1 for UI thing
            private _channels = GET_STATE("channels");
            private _channel = _channels select _currentChannel;
            private _freq = HASH_GET(_channel,"frequencyRX");

            if (_freq > 69) then { // If freq invalid display no frequency
                RADIO_CTRL(301) ctrlSetText (_complete select 1); // noFr
            } else {
                _currentChannel = _currentChannel + 1; // +1 to convert from index to display channel.
                if (_currentChannel == 13) then { // H
                    RADIO_CTRL(301) ctrlSetText (_complete select 2);
                    RADIO_CTRL(304) ctrlSetText (_fourthDigit select 10);
                } else {
                    if (_currentChannel > 9) then {
                        RADIO_CTRL(301) ctrlSetText (_complete select 3);
                        RADIO_CTRL(304) ctrlSetText (_fourthDigit select (_currentChannel-10));
                    } else {
                        RADIO_CTRL(301) ctrlSetText (_complete select 2);
                        RADIO_CTRL(304) ctrlSetText (_fourthDigit select _currentChannel);
                    };
                };
            };
        };
        case 15: { // P - Programming mode
            // Pr <H>
            // Step 1) choose channel (push PTT)
            // (then show current freq for that channel)
            //
            private _step = GET_STATE("programmingStep");
            switch _step do {
                //PTT used as confirm
                case 0: {  // select channels - Starting with H
                    private _currentChannel = GVAR(selectedChannel) + 1;
                    if (_currentChannel == 13) then { // H
                        RADIO_CTRL(301) ctrlSetText (_complete select 2);
                        if (GVAR(alternate)) then { // blink
                            RADIO_CTRL(304) ctrlSetText (_fourthDigit select 10);
                        };
                    } else {
                        if (_currentchannel > 9) then {
                            RADIO_CTRL(301) ctrlSetText (_complete select 3);
                            if (GVAR(alternate)) then { // blink
                                RADIO_CTRL(304) ctrlSetText (_fourthDigit select (_currentChannel-10));
                            };
                        } else {
                            RADIO_CTRL(301) ctrlSetText (_complete select 2);
                            if (GVAR(alternate)) then { // blink
                                RADIO_CTRL(304) ctrlSetText (_fourthDigit select _currentChannel);
                            };
                        };
                    };
                };
                case 1: { // MHZ selector (blinking)

                    private _freq = GVAR(newFrequency);
                    private _numbers = [_freq] call _fnc_formatNumber;
                    if (GVAR(alternate)) then {
                        switch (_numbers select 0) do {
                            case 0: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 0); };
                            case 4: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 1); };
                            case 5: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 2); };
                            case 6: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 3); };
                            case 8: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 4); };
                        };
                        RADIO_CTRL(302) ctrlSetText (_secondDigit select (_numbers select 1));
                    };
                    RADIO_CTRL(303) ctrlSetText (_thirdDigit select (_numbers select 2));
                    RADIO_CTRL(304) ctrlSetText (_fourthDigit select (_numbers select 3));
                    switch (_numbers select 4) do {
                        case 0: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 0); };
                        case 2: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 1); };
                        case 5: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 2); };
                        case 6: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 3); };
                        case 8: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 4); };
                    };

                };
                case 2: { // Khz selector (blinking)
                    private _freq = GVAR(newFrequency);
                    private _numbers = [_freq] call _fnc_formatNumber;
                    switch (_numbers select 0) do {
                        case 0: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 0); };
                        case 4: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 1); };
                        case 5: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 2); };
                        case 6: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 3); };
                        case 8: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 4); };
                    };
                    RADIO_CTRL(302) ctrlSetText (_secondDigit select (_numbers select 1));
                    if (GVAR(alternate)) then {
                        RADIO_CTRL(303) ctrlSetText (_thirdDigit select (_numbers select 2));
                        RADIO_CTRL(304) ctrlSetText (_fourthDigit select (_numbers select 3));
                        switch (_numbers select 4) do {
                            case 0: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 0); };
                            case 2: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 1); };
                            case 5: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 2); };
                            case 6: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 3); };
                            case 8: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 4); };
                        };
                    };
                }; // PTT = confirm (back to step 0).
            };
        };
        default {
            private _currentChannel = GET_STATE("currentChannel");
            private _channels = GET_STATE("channels");
            private _channel = _channels select _currentChannel;
            private _freq = HASH_GET(_channel,"frequencyRX");

            if (_freq > 69) then { // out of bounds frequency (technically only possible for channel 13)
                RADIO_CTRL(301) ctrlSetText (_complete select 1); // noFr (on boot)
            } else {
                private _numbers = [_freq] call _fnc_formatNumber;
                switch (_numbers select 0) do {
                    case 0: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 0); };
                    case 4: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 1); };
                    case 5: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 2); };
                    case 6: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 3); };
                    case 8: { RADIO_CTRL(301) ctrlSetText (_firstDigit select 4); };
                };
                RADIO_CTRL(302) ctrlSetText (_secondDigit select (_numbers select 1));
                RADIO_CTRL(303) ctrlSetText (_thirdDigit select (_numbers select 2));
                RADIO_CTRL(304) ctrlSetText (_fourthDigit select (_numbers select 3));
                switch (_numbers select 4) do {
                    case 0: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 0); };
                    case 2: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 1); };
                    case 5: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 2); };
                    case 6: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 3); };
                    case 8: { RADIO_CTRL(305) ctrlSetText (_fifthDigit select 4); };
                };
            };

            // show frequency...
        }; // chan
};

/*+ 1;
if (_currentchannel > 9) then {
    RADIO_CTRL(301) ctrlSetText (_complete select 3);
    RADIO_CTRL(304) ctrlSetText (_fourthDigit select (_currentChannel-10));
} else {
    RADIO_CTRL(301) ctrlSetText (_complete select 2);
    RADIO_CTRL(304) ctrlSetText (_fourthDigit select _currentChannel);
};*/
