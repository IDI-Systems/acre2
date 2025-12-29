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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

#define GET_RADIO_VALUE(x) [x] call FUNC(CURRENT_RADIO_VALUE)
#define GET_CHANNEL_DATA [] call FUNC(CURRENT_RADIO_CHANNEL);

GVAR(SQ_ONLY_AM) = ["SQ_ONLY_FM", "SQ_ONLY_FM", "",
    MENUTYPE_STATIC,
    [
        [ROW_LARGE_2, ALIGN_CENTER, "N/A FOR AM MODULATION"]
    ],
    [
        {

        }, // onEntry
        nil, // onExit
        {
            TRACE_1("ERROR_NOENTRY:onButtonPress",(_this select 1));
            if (((_this select 1) select 0) == "ENT" || ((_this select 1) select 0) == "CLR") then {
                TRACE_1("BACK TO HOME","");
                private _home = GET_STATE_DEF("currentHome",GVAR(VULOSHOME));
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
                    SET_STATE("menuSelection",1);
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
        private _selectDigital = SCRATCH_GET(GVAR(currentRadioID),"sq_select_digital");

        switch _selectDigital do {
            case 'ON': {_selectDigital = true; };
            case 'OFF': {_selectDigital = false; };
            default {_selectDigital = false; };
        };

        SCRATCH_SET(GVAR(currentRadioID),"sq_select_digital",nil);

        if (_selectDigital) exitWith {
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
                    private _mode = "";
                    private _ctcss = GET_RADIO_VALUE("CTCSSRx");
                    private _squelch = GET_RADIO_VALUE("squelch");
                    SET_STATE("menuSelection",0);

                    if (_ctcss > 0) then {
                        _mode = "CTCSS";
                        if (_ctcss == 150) then {
                            _mode = "TONE";
                        };
                    } else {
                        if (_squelch == 0) then {
                            _mode = "OFF";
                        } else {
                            _mode = "NOISE";
                        };
                        
                    };

                    private _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                    {
                        private _modeInt = _x;
                        if (_modeInt == _mode) exitWith {
                            TRACE_1("FOUND MATCH",_forEachIndex);
                            SET_STATE("menuSelection",_forEachIndex);
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
        private _selectAnalogSquelch = SCRATCH_GET(GVAR(currentRadioID),"sq_select_analog"); 

        private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
        private _channels = GET_STATE("channels");
        private _channel = HASHLIST_SELECT(_channels,_channelNumber);

        private _CTCSSTx = HASH_GET(_channel,"CTCSSTx");
        private _CTCSSRx = HASH_GET(_channel,"CTCSSRx");
        private _squelch = HASH_GET(_channel,"squelch");
        private _modulation = HASH_GET(_channel,"modulation");

        private _nextMenu = "";
        if (_modulation == "FM") then{
            switch _selectAnalogSquelch do {
                case 'OFF': {_CTCSSTx = 0; _CTCSSRx = 0; _squelch = 0; };
                case 'TONE': {_CTCSSTx = 150; _CTCSSRx = 150;; _squelch = 3; };
                case 'NOISE': {_CTCSSTx = 0; _CTCSSRx = 0; _squelch = 3;};
                case 'CTCSS': {_squelch = 3; _nextMenu="SQ_SELECT_CTCSS";};
                case 'CDCSS': {_nextMenu="NOT_IMPLEMENTED";};
                default {_selectAnalogSquelch = -1;_nextMenu="ERROR_NOENTRY";};
            };
        } else {
            switch _selectAnalogSquelch do {
                case 'OFF': {_CTCSSTx = 0; _CTCSSRx = 0; _squelch = 0; };
                case 'NOISE': { _CTCSSTx = 0; _CTCSSRx = 0; _nextMenu="SQ_SELECT_SQUELCH";};                
                default {_selectAnalogSquelch = 2;  _CTCSSTx = 0; _CTCSSRx = 0; _nextMenu="SQ_ONLY_FM";};
            };
        };
        
        HASH_SET(_channel,"CTCSSTx",_CTCSSTx);
        HASH_SET(_channel,"CTCSSRx",_CTCSSRx);
        HASH_SET(_channel,"squelch",_squelch);
        
        
        SCRATCH_SET(GVAR(currentRadioID),"sq_select_analog",nil);
        _selectAnalogSquelch = 4;
        
        if (_nextMenu != "") exitWith {
            
            [_nextMenu] call FUNC(changeMenu);
        };
        HASHLIST_SET(_channels,_channelNumber,_channel);
        SET_STATE("channels",_channels);  
        private _home = GET_STATE_DEF("currentHome",GVAR(VULOSHOME));
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
                    private _squelch = GET_RADIO_VALUE("squelch");
                    if (_squelch == 0) then {
                        _squelch = 3;
                    };
                    _squelch=_squelch-1;
                    SET_STATE("menuSelection",_squelch);
                    

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
        private _selectSquelch = SCRATCH_GET(GVAR(currentRadioID),"sq_select_squelch");
        private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
        private _channels = GET_STATE("channels");
        private _channel = HASHLIST_SELECT(_channels,_channelNumber);
        private _squelch = HASH_GET(_channel,"squelch");

        switch _selectSquelch do {
            case 'LOW': {_selectSquelch = 1; };
            case 'LOW-MED': {_selectSquelch = 2; };
            case 'MED': {_selectSquelch = 3; };
            case 'MED HIGH': {_selectSquelch = 4; };
            case 'HIGH': {_selectSquelch = 5; };
            default {_selectSquelch = -1; };
        };

        if (_selectSquelch < 0) exitWith {
            ["ERROR_NOENTRY"] call FUNC(changeMenu);
        };

        HASH_SET(_channel,"squelch",_selectSquelch);      
        HASHLIST_SET(_channels,_channelNumber,_channel);
        SET_STATE("channels",_channels);  
        SCRATCH_SET(GVAR(currentRadioID),"sq_select_squelch",nil);
        private _home = GET_STATE_DEF("currentHome",GVAR(VULOSHOME));
        [_home] call FUNC(changeMenu);
        true
    },
    "VULOSHOME"
];
[GVAR(SQ_SELECT_SQUELCH)] call FUNC(createMenu);


GVAR(SQ_SELECT_CTCSS) = ["SQ_SELECT_CTCSS", "SQ_SELECT_CTCSS", "",
    MENUTYPE_ACTIONSERIES,
    [
        [nil, "SQ_SELECT_CTCSSTx", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "CTCSS TX TONE"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    private _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                    private _txTone = GET_RADIO_VALUE("CTCSSTx");
                    {
                        if (_txTone ==  (parseNumber _x))exitWith {
                            SET_STATE("menuSelection",_forEachIndex);
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
            "sq_select_ctcsstx"
        ],
        [nil, "RX_SQUELCH_TYPE", "",
        MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "RX SQUELCH TYPE"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    SCRATCH_SET(GVAR(currentRadioId),"pgm_sq_rx_select","CTCSS");
                    SET_STATE("menuSelection",1);
                },
                nil,
                nil,
                nil,
                {
                    //_sqTone = SCRATCH_GET_DEF(GVAR(currentRadioId),"pgm_sq_tx_ctcss_tone","250.3");
                    private _sqType = SCRATCH_GET_DEF(GVAR(currentRadioId),"pgm_sq_rx_select","CTCSS");
                    switch _sqType do {
                        default {        // Default is go to end, we only have 1 configurable SQ for now
                            SCRATCH_SET(GVAR(currentRadioId),"sq_select_ctcssrx", "0");
                            
                            private _currentAction = GET_STATE("menuAction");
                            _currentAction = _currentAction + 999;
                            SET_STATE("menuAction",_currentAction);
                        };
                        case 'CTCSS': {
                            // Next menu is CTCSS
                        };
                    };
                }
            ],
            [
                ["DISABLED", "CTCSS", "NOISE"],
                [ROW_LARGE_3, 0, -1]
            ],
            "pgm_sq_rx_select"
        ],
        [nil, "SQ_SELECT_CTCSSRx", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "CTCSS RX TONE"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    private _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                    private _txTone = SCRATCH_GET(GVAR(currentRadioId),"sq_select_ctcsstx");
                    {
                        if (_txTone ==  _x )exitWith {
                            SET_STATE("menuSelection",_forEachIndex);
                        };
                    } forEach _options;
                },
                nil,
                nil,
                nil,
                {
                    //_sqTone = SCRATCH_GET_DEF(GVAR(currentRadioId),"pgm_sq_tx_ctcss_tone","250.3");
                }
            ],
            [
                ["67.0", "69.3", "71.9", "74.4", "77.0", "79.7", "82.5", "85.4", "88.5", "91.5", "94.8", "97.4", "100.0", "103.5", "107.2", "110.9", "114.8", "118.8", "123.0", "127.3", "131.8", "136.5", "141.3", "146.2", "151.4", "156.7", "162.2", "167.9", "173.8", "179.9", "186.2", "192.8", "203.5", "206.5", "210.7", "218.1", "225.7", "229.1", "233.6", "241.8", "250.3", "254.1" ],
                [ROW_LARGE_3, 0, -1]
            ],
            "sq_select_ctcssrx"
        ]
    ],
    [
        nil,
        nil
    ],
    {
        //Call on series completion
        private _selectctcsstx = SCRATCH_GET(GVAR(currentRadioID),"sq_select_ctcsstx");
        private _selectctcssrx = SCRATCH_GET(GVAR(currentRadioID),"sq_select_ctcssrx");
        private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
        private _channels = GET_STATE("channels");
        private _channel = HASHLIST_SELECT(_channels,_channelNumber);
        
        private _ctcsstx = parseNumber _selectctcsstx;
        private _ctcssrx = parseNumber _selectctcssrx;
        HASH_SET(_channel,"CTCSSRx",_ctcssrx);
        HASH_SET(_channel,"CTCSSTx",_ctcsstx);
        HASHLIST_SET(_channels,_channelNumber,_channel);
        SET_STATE("channels",_channels);  
        SCRATCH_SET(GVAR(currentRadioID),"sq_select_ctcsstx",nil);
        SCRATCH_SET(GVAR(currentRadioID),"sq_select_ctcssrx",nil);
        false
    },
    "VULOSHOME"
];
[GVAR(SQ_SELECT_CTCSS)] call FUNC(createMenu);
