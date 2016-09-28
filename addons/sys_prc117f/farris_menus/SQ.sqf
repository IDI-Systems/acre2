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

#define GET_RADIO_VALUE(x) [x] call FUNC(CURRENT_RADIO_VALUE)
#define GET_CHANNEL_DATA() [] call FUNC(CURRENT_RADIO_CHANNEL);

GVAR(SQ_ONLY_AM) = ["SQ_ONLY_AM", "SQ_ONLY_AM", "",
    MENUTYPE_STATIC,
    [
        [ROW_LARGE_2, ALIGN_CENTER, "N/A FOR FM MODULATION"]
    ],
    [
        {

        }, // onEntry
        nil, // onExit
        {
            TRACE_1("ERROR_NOENTRY:onButtonPress", (_this select 1));
            if(((_this select 1) select 0) == "ENT" || ((_this select 1) select 0) == "CLR") then {
                TRACE_1("BACK TO HOME", "");
                _home = GET_STATE_DEF("currentHome", GVAR(VULOSHOME));
                [_home] call FUNC(changeMenu);
            };
            true
        }
    ]
];
[GVAR(SQ_ONLY_AM)] call FUNC(createMenu);

GVAR(SQ) = ["SQ", "SQ", "Squelch Settings",
    MENUTYPE_ACTIONSERIES,
    [
        [nil, "SQ_SELECT_DIGITAL", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "DIGITAL SQUELCH"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    // Need to pull the current squelch type and check if its digital currently
                    // As there is no digital currently (and the value is not saved), we are going with OFF all the time
                    SET_STATE("menuSelection", 1);
                }, // onEntry
                nil,
                nil
            ],
            [
                ["ON", "OFF"],
                [ROW_LARGE_3, 0, -1]
            ],
            "sq_select_digital"
        ]
    ],
    [
        nil,
        nil
    ],
    {
        //Call on series completion
        _selectDigital = SCRATCH_GET(GVAR(currentRadioID), "sq_select_digital");

        switch _selectDigital do {
            case 'ON': {_selectDigital = true; };
            case 'OFF': {_selectDigital = false; };
            default {_selectDigital = false; };
        };

        SCRATCH_SET(GVAR(currentRadioID), "sq_select_digital", nil);

        if(_selectDigital) exitwith {
            ["NOT_IMPLEMENTED"] call FUNC(changeMenu);
            true
        };

        ["SQ_NO_DIGITAL"] call FUNC(changeMenu);
        true
    },
    "PGM_NORM_LOS"
];
[GVAR(SQ)] call FUNC(createMenu);



GVAR(SQ_NO_DIGITAL) = ["SQ_NO_DIGITAL", "SQ_NO_DIGITAL", "",
    MENUTYPE_ACTIONSERIES,
    [
        [nil, "SQ_SELECT_DIGITAL", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "ANALOG SQUELCH TYPE"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    // Need to pull the current squelch type and set to selection correctly
                    TRACE_1("Entering ctcss value","");
                    _mode = "";
                    _ctcss = GET_RADIO_VALUE("CTCSSRx");
                    _squelch  = GET_RADIO_VALUE("squelch");
                    SET_STATE("menuSelection", 0);

                    if (_ctcss > 0) then {
                        _mode = "CTCSS";
                        if (_ctcss == 150) then {
                            _mode = "TONE";
                        };
                    } else {
                        _mode = "OFF";
                    };

                    _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                    {
                        _modeInt = _x;
                        if(_modeInt == _mode) exitWith {
                            TRACE_1("FOUND MATCH", _forEachIndex);
                            SET_STATE("menuSelection", _forEachIndex);
                        };
                    } forEach _options;
                }, // onEntry,
                nil,
                nil,
                {},
                "SQ"
            ],
            [
                ["OFF", "TONE", "NOISE", "CTCSS", "CDCSS"],
                [ROW_LARGE_3, 0, -1]
            ],
            "sq_select_analog"
        ]
    ],
    [
        nil,
        nil
    ],
    {
        //Call on series completion
        _selectAnalogSquelch = SCRATCH_GET(GVAR(currentRadioID), "sq_select_analog");
        _channel = GET_CHANNEL_DATA();
        _CTCSS = HASH_GET(_channel, "CTCSSRx");
        _squelch = HASH_GET(_channel, "squelch");
        _modulation = HASH_GET(_channel, "modulation");

        switch _selectAnalogSquelch do {
            case 'OFF': {_selectAnalogSquelch = 0; _CTCSS = 0; _squelch = 0; };
            case 'TONE': {_selectAnalogSquelch = 1; _CTCSS = 150; _squelch = 3; };
            case 'NOISE': {_selectAnalogSquelch = 2;  _CTCSS = 0; };
            case 'CTCSS': {_selectAnalogSquelch = 3; _squelch = 3; };
            case 'CDCSS': {_selectAnalogSquelch = 4; };
            default {_selectAnalogSquelch = -1; };
        };

        if(_selectAnalogSquelch < 0) exitWith {
            ["ERROR_NOENTRY"] call FUNC(changeMenu);
        };

        HASH_SET(_channel, "CTCSSTx", _CTCSS);
        HASH_SET(_channel, "CTCSSRx", _CTCSS);
        HASH_SET(_channel, "squelch", _squelch);

        SCRATCH_SET(GVAR(currentRadioID), "sq_select_analog", nil);

        if(_selectAnalogSquelch > 1) exitWith {
            if(_selectAnalogSquelch > 2) exitWith {
                if (_selectAnalogSquelch > 3) exitWith {
                    ["NOT_IMPLEMENTED"] call FUNC(changeMenu);
                    true
                };
                ["SQ_SELECT_CTCSS"] call FUNC(changeMenu);
                true
            };
            if (_modulation == "AM") then {
                ["SQ_SELECT_SQUELCH"] call FUNC(changeMenu);
                true
            } else {
                ["SQ_ONLY_AM"] call FUNC(changeMenu);
                true
            };
        };
        _home = GET_STATE_DEF("currentHome", GVAR(VULOSHOME));
        [_home] call FUNC(changeMenu);
        true
    },
    "SQ"
];
[GVAR(SQ_NO_DIGITAL)] call FUNC(createMenu);


GVAR(SQ_SELECT_SQUELCH) = ["SQ_SELECT_SQUELCH", "SQ_SELECT_SQUELCH", "",
    MENUTYPE_ACTIONSERIES,
    [
        [nil, "SQ_SELECT_SQUELCH", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "ANALOG SQUELCH LEVEL"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    // Need to pull the current squelch type and set to selection correctly

                }, // onEntry,,
                nil,
                nil
            ],
            [
                ["LOW", "LOW-MED", "MED", "MED HIGH", "HIGH"],
                [ROW_LARGE_3, 0, -1]
            ],
            "sq_select_squelch"
        ]
    ],
    [
        nil,
        nil
    ],
    {
        //Call on series completion
        _selectSquelch = SCRATCH_GET(GVAR(currentRadioID), "sq_select_squelch");
        _channel = GET_CHANNEL_DATA();
        _squelch = HASH_GET(_channel, "squelch");

        switch _selectSquelch do {
            case 'LOW': {_selectSquelch = 1; };
            case 'LOW-MED': {_selectSquelch = 2; };
            case 'MED': {_selectSquelch = 3; };
            case 'MED HIGH': {_selectSquelch = 4; };
            case 'HIGH': {_selectSquelch = 5; };
            default {_selectSquelch = -1; };
        };

        if(_selectSquelch < 0) exitWith {
            ["ERROR_NOENTRY"] call FUNC(changeMenu);
        };

        HASH_SET(_channel, "squelch", _squelch);

        SCRATCH_SET(GVAR(currentRadioID), "sq_select_squelch", nil);

    },
    "SQ_NO_DIGITAL"
];
[GVAR(SQ_SELECT_SQUELCH)] call FUNC(createMenu);


GVAR(SQ_SELECT_CTCSS) = ["SQ_SELECT_CTCSS", "SQ_SELECT_CTCSS", "",
    MENUTYPE_ACTIONSERIES,
    [
        [nil, "SQ_SELECT_CTCSS", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "SELECT CTCSS FREQ"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    TRACE_1("Entering ctcss value","");
                    _ctcss = GET_RADIO_VALUE("CTCSSRx");
                    SET_STATE("menuSelection", 0);

                    _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                    {
                        _ctcssInt = (parseNumber _x);
                        TRACE_2("COMPARE", _ctcssInt, _ctcss);
                        if(_ctcssInt == _ctcss) exitWith {
                            TRACE_1("FOUND MATCH", _forEachIndex);
                            SET_STATE("menuSelection", _forEachIndex);
                        };
                    } forEach _options;
                }, // onEntry,,
                nil,
                nil
            ],
            [
                ["67.0", "69.3", "71.9", "74.4", "77.0", "79.7", "82.5", "85.4", "88.5", "91.5", "94.8", "97.4", "100.0", "103.5", "107.2", "110.9", "114.8", "118.8", "123.0", "127.3", "131.8", "136.5",    "141.3", "146.2", "151.4", "156.7", "162.2", "167.9", "173.8", "179.9", "186.2", "192.8", "203.5", "210.7", "218.1", "225.7", "233.6", "241.8", "250.3"
                ],
                [ROW_LARGE_3, 0, -1]
            ],
            "sq_select_ctcss"
        ]
    ],
    [
        nil,
        nil
    ],
    {
        //Call on series completion
        _selectctcss = SCRATCH_GET(GVAR(currentRadioID), "sq_select_ctcss");
        _channel = GET_CHANNEL_DATA();
        _ctcss = HASH_GET(_channel, "CTCSSRx");

        _ctcss = parseNumber _selectctcss;

        HASH_SET(_channel, "CTCSSRx", _ctcss);
        HASH_SET(_channel, "CTCSSTx", _ctcss);
        TRACE_1("SERIES COMPLETE ON CTCSS", _ctcss);
        SCRATCH_SET(GVAR(currentRadioID), "sq_select_ctcss", nil);
        false
    },
    "VULOSHOME"
];
[GVAR(SQ_SELECT_CTCSS)] call FUNC(createMenu);
