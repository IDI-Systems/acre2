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

DFUNC(DefaultDisplay_Render) = {
    params["_display"];

    [_display, ICON_BATTERY, true] call FUNC(showIcon);
    [_display, ICON_BATSTRENGTH, true] call FUNC(showIcon);

    if(SCRATCH_GET_DEF(GVAR(currentRadioId), "squelchOpen", false)) then {
        [_display, ICON_SQUELCH, true] call FUNC(showIcon);
    };

    [_display, ICON_EXTERNAL, true] call FUNC(showIcon);
    //[_display, ICON_SIDECONNECTOR, true] call FUNC(showIcon);


    _group = GET_STATE(groups) select GET_STATE(currentGroup);

    _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
    _groupLabel = _group select 0;

    _channel = HASHLIST_SELECT(GET_STATE(channels), _channelNumber);

    _channelLabel = HASH_GET(_channel, "label");

    SET_TEXT(_groupLabel, SMALL_LINE_1, 6, 8);
    SET_TEXT(_channelLabel, SMALL_LINE_2, 6, 12);
    if(GET_STATE_DEF(SAEnabled, false)) then {
        SET_TEXT("SA", SMALL_LINE_4, 9, 10);
    };

    if(HASH_GET(_channel, "encryption") == 1) then {
        SET_TEXT("CT", SMALL_LINE_5, 9, 10);
    } else {
        SET_TEXT("PT", SMALL_LINE_5, 9, 10);
    };
    _channelMode = HASH_GET(_channel, "channelMode");
    switch _channelMode do {
        case "BASIC": {
            _modulation = HASH_GET(_channel, "modulation");
            SET_TEXT(_modulation, SMALL_LINE_5, 14, 15);
        };
    };
    //diag_log text format["channel: %1", _channel];
    /*
    [_display, SMALL_LINE_1, format["      %1",], LEFT_ALIGN] call FUNC(displayLine);
    [_display, SMALL_LINE_2, "     CHAN 01", LEFT_ALIGN] call FUNC(displayLine);
    [_display, SMALL_LINE_4, "        SA", LEFT_ALIGN] call FUNC(displayLine);
    [_display, SMALL_LINE_5, "    LNE PT SG FH FM", LEFT_ALIGN] call FUNC(displayLine);
    */

    // [_display, BIG_LINE_1, "          NOPWR", LEFT_ALIGN] call FUNC(displayLine);

    // [_display, BIG_LINE_1, [11,15]] call FUNC(startFlashText);
};

DFUNC(DefaultDisplay_ENT) = {
    [GVAR(currentRadioId), "AlternateDisplay"] call FUNC(changeState);
};

DFUNC(AlternateDisplay_Render) = {
    params["_display"];

    _group = GET_STATE(groups) select GET_STATE(currentGroup);
    _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;

    _channel = HASHLIST_SELECT(GET_STATE(channels), _channelNumber);

    _channelMode = HASH_GET(_channel, "channelMode");
    switch _channelMode do {
        case "BASIC": {

            _fTX = HASH_GET(_channel, "frequencyTX");
            _fRX = HASH_GET(_channel, "frequencyRX");
            // _fTX = 167.5625;
            // _fRX = _fTX;
            _cTX = HASH_GET(_channel, "CTCSSTx");
            _cRX = HASH_GET(_channel, "CTCSSRx");

            _modulation = HASH_GET(_channel, "modulation");
            _trafficRate = HASH_GET(_channel, "trafficRate");
            _TEK = HASH_GET(_channel, "TEK");
            //acre_player sideChat format["_fTX: %1", _fTX];
            // [_display, SMALL_LINE_1, format[" RX = %1", ([_fRX] call FUNC(frequencyToString))], LEFT_ALIGN] call FUNC(displayLine);
            // [_display, SMALL_LINE_2, format[" TX = %1", ([_fRX] call FUNC(frequencyToString))], LEFT_ALIGN] call FUNC(displayLine);
            SET_TEXT("RX =", SMALL_LINE_1, 2, 5);
            [_display, SMALL_LINE_1, [7, 16], ([_fRX] call FUNC(frequencyToString)), "###.#####"] call FUNC(setText);
            SET_TEXT("TX =", SMALL_LINE_2, 2, 5);
            [_display, SMALL_LINE_2, [7, 16], ([_fTX] call FUNC(frequencyToString)), "###.#####"] call FUNC(setText);


            _cRxStr = format["R = %1", _cRX];
            _cTxStr = format["T = %1", _cRX];

            SET_TEXT(_cRxStr, SMALL_LINE_3, 2, 10);
            SET_TEXT(_cTxStr, SMALL_LINE_3, 15, 23);

            SET_TEXT(_modulation, SMALL_LINE_5, 2, 3);
            SET_TEXT((str _trafficRate) + "K", SMALL_LINE_5, 10, 12);
            SET_TEXT("TEK " + (str _TEK), SMALL_LINE_5, 19, 23);

        };
    };
};

DFUNC(AlternateDisplay_ESC) = {
    [GVAR(currentRadioId), "DefaultDisplay"] call FUNC(changeState);
};

DFUNC(AlternateDisplay_ENT) = {
    [GVAR(currentRadioId), "DefaultDisplay"] call FUNC(changeState);
};
