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
#include "\idi\acre\addons\sys_prc148\script_component.hpp"

DFUNC(ChannelDisplay_ESC) = {
    [GVAR(currentRadioId), "ProgramDisplay"] call FUNC(changeState);
};

DFUNC(ChannelDisplay_Render) = {
    params["_display"];
    _group = GET_STATE(groups) select GET_STATE(currentGroup);

    _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
    _groupLabel = _group select 0;

    _channel = HASHLIST_SELECT(GET_STATE(channels), _channelNumber);

    _channelType = HASH_GET(_channel, "channelMode");
    _pageIndex = PAGE_INDEX;
    GVAR(currentMenu) = [];

    if(_pageIndex == 0) then {
        SET_TEXT("CH = ", BIG_LINE_1, 2, 6);
        SET_TEXT("PWR = ", BIG_LINE_3, 2, 7);
    };
    _pageOne = [];
    _channelNumberTxt = str (_channelNumber+1);
    if(_channelNumber+1 < 10) then {
        _channelNumberTxt = "00" + _channelNumberTxt;
    } else {
        if(_channelNumber+1 < 100) then {
            _channelNumberTxt = "0" + _channelNumberTxt;
        };
    };
    _pageOne pushBack ["CHANNEL", _channelNumberTxt, BIG_LINE_1, [7, 9], MENU_TYPE_MENU, {}];
    _encryption = "PLAIN";
    if(HASH_GET(_channel, "encryption") == 1) then {
        _encryption = "SECURE";
    };
    _pageOne pushBack ["encryption", HASH_GET(_channel, "encryption"), BIG_LINE_1, [12, 17], MENU_TYPE_LIST, FUNC(updateChannelData), ["PLAIN", "SECURE"], [0,1]];
    _pageOne pushBack ["label", HASH_GET(_channel, "label"), BIG_LINE_2, [2, 8], MENU_TYPE_TEXT, FUNC(updateChannelData)];
    _powersList = [["0.1 W", "0.5 W", "1.0 W", "3.0 W", "5.0 W"], [100, 500, 1000, 3000, 5000]];
    _pageOne set[4, ["channelMode", _channelType, BIG_LINE_4, [2, 9], MENU_TYPE_LIST, FUNC(updateChannelData), ["BASIC"], ["BASIC"]]];
    // //acre_player sideChat format["page: %1", _pageIndex];
    switch (_channelType) do {
        case "BASIC": {
            switch _pageIndex do {
                case 1: {
                    SET_TEXT("RX = ", BIG_LINE_1, 1, 5);
                    SET_TEXT("TX = ", BIG_LINE_2, 1, 5);
                    SET_TEXT("R = ", BIG_LINE_3, 1, 4);
                    SET_TEXT("T = ", BIG_LINE_3, 10, 14);
                    SET_TEXT("TEK ", BIG_LINE_4, 11, 14);

                };
                case 2: {
                    SET_TEXT("RPTR", BIG_LINE_1, 1, 4);
                    SET_TEXT("FADE", BIG_LINE_2, 1, 4);
                    SET_TEXT("PHASE", BIG_LINE_3, 1, 5);
                    SET_TEXT("SQLCH", BIG_LINE_4, 1, 5);

                };
            };
            _ctcssList = [0, 67.0, 69.3, 71.9, 74.4, 77.0, 79.7, 82.5, 85.4, 88.5, 91.5,
                            94.8, 97.4, 100.0, 103.5, 107.2, 110.9, 114.8, 118.8, 123.0, 127.3, 131.8, 136.5,
                            141.3, 146.2, 150.0, 151.4, 156.7, 162.2, 167.9, 173.8, 179.9, 186.2, 192.8, 203.5,
                            210.7, 218.1, 225.7, 233.6, 241.8, 250.3
                        ];
            _ctcssLabelList = +_ctcssList;
            _ctcssLabelList set[0, "OFF"];
            if(HASH_GET(_channel, "modulation") == "AM") then {
                _ctcssList = [0];
                _ctcssLabelList = ["OFF"];
                _powersList = [["1.0 W", "5.0 W"], [1000, 5000]];
            };
            // //diag_log text format["freq: %1 %2", ([HASH_GET(_channel, "frequencyRX")] call FUNC(frequencyToString)), HASH_GET(_channel, "frequencyRX")];
            _tekList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
            _page2 = [
                        ["frequencyRX", ([HASH_GET(_channel, "frequencyRX")] call FUNC(frequencyToString)), BIG_LINE_1, [6, 14], MENU_TYPE_NUM, FUNC(updateChannelData), "###.#####"],
                        ["frequencyTX", ([HASH_GET(_channel, "frequencyTX")] call FUNC(frequencyToString)), BIG_LINE_2, [6, 14], MENU_TYPE_NUM, FUNC(updateChannelData), "###.#####"],
                        ["CTCSSRx", HASH_GET(_channel, "CTCSSRx"), BIG_LINE_3, [5, 9], MENU_TYPE_LIST, FUNC(updateChannelData), _ctcssLabelList, _ctcssList],
                        ["CTCSSTx", HASH_GET(_channel, "CTCSSTx"), BIG_LINE_3, [14, 18], MENU_TYPE_LIST, FUNC(updateChannelData), _ctcssLabelList, _ctcssList],
                        ["modulation", HASH_GET(_channel, "modulation"), BIG_LINE_4, [1, 2], MENU_TYPE_LIST, FUNC(updateChannelData), ["AM", "FM", "NB"], ["AM", "FM", "NB"]],
                        ["trafficRate", HASH_GET(_channel, "trafficRate"), BIG_LINE_4, [6, 8], MENU_TYPE_LIST, FUNC(updateChannelData), ["12K", "16K"], [12, 16]],
                        ["TEK", HASH_GET(_channel, "TEK"), BIG_LINE_4, [15, 16], MENU_TYPE_LIST, FUNC(updateChannelData), _tekList, _tekList]
                    ];
            _page3 = [
                ["RPTR", HASH_GET(_channel, "RPTR"), BIG_LINE_1, [7, 10], MENU_TYPE_LIST, FUNC(updateChannelData), ["0.2S", "0.4S", "0.6S", "0.8S", "1.0S", "NONE"], [0.2, 0.4, 0.6, 0.8, 1.0, 0]],
                ["fade", HASH_GET(_channel, "fade"), BIG_LINE_2, [7, 10], MENU_TYPE_LIST, FUNC(updateChannelData), ["1.0S", "2.0S", "3.0S", "4.0S", "0.0S"], [1, 2, 3, 4, 0]],
                ["phase", HASH_GET(_channel, "phase"), BIG_LINE_3, [7, 11], MENU_TYPE_LIST, FUNC(updateChannelData), ["OFF", ".256S", ".384S", "1.06S"], [0, 256, 384, 1060]],
                ["squelch", HASH_GET(_channel, "squelch"), BIG_LINE_4, [7, 7], MENU_TYPE_LIST, FUNC(updateChannelData), [0, 1, 2, 3, 4, 5, 6, 7], [0, 1, 2, 3, 4, 5, 6, 7]]
            ];
            GVAR(currentMenu) set[1, _page2];
            GVAR(currentMenu) set[2, _page3];

        };
    };

    _pageOne set[3, ["power", HASH_GET(_channel, "power"), BIG_LINE_3, [7, 11], MENU_TYPE_LIST, FUNC(updateChannelData), _powersList select 0, _powersList select 1]];
    GVAR(currentMenu) set[0, _pageOne];
    [_display, GVAR(currentMenu)] call FUNC(showMenu);
};
