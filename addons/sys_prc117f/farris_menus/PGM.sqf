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

DFUNC(CURRENT_RADIO_VALUE) = {
    private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
    private _channels = GET_STATE("channels");
    private _channel = HASHLIST_SELECT(_channels,_channelNumber);
    private _value = HASH_GET(_channel,(_this select 0));
    _value
};
DFUNC(CURRENT_RADIO_CHANNEL) = {
    private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
    private _channels = GET_STATE("channels");
    private _channel = HASHLIST_SELECT(_channels,_channelNumber);
    _channel
};

GVAR(PGM) = ["PGM", "PGM", "",
    MENUTYPE_LIST,
    [
        [nil, "NORM", "", MENU_ACTION_SUBMENU, ["PGM_NORM"], nil ],
        [nil, "SCAN", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "CFIG", "", MENU_ACTION_SUBMENU, ["PGM_CFIG"], nil ],
        [nil, "SECUR", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "PORTS", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "DAMA", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
    ],
    nil
];
[GVAR(PGM)] call FUNC(createMenu);

GVAR(PGM_CFIG) = ["PGM_CFIG", "PGM_CFIG", "",
    MENUTYPE_LIST,
    [
        [nil, "GENERAL", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "EXT_DEV", "", MENU_ACTION_SUBMENU, ["EXT_DEV"], nil ],
        [nil, "BEACON", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "GPS", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "FREQ ID", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
    ],
    nil
];
[GVAR(PGM_CFIG)] call FUNC(createMenu);

GVAR(EXT_DEV) = ["EXT_DEV", "EXT_DEV", "",
    MENUTYPE_LIST,
    [
        [nil, "VAU", "", MENU_ACTION_SUBMENU, ["EXTERNAL_POWER"], nil ]
    ],
    nil
];
[GVAR(EXT_DEV)] call FUNC(createMenu);

[["EXTERNAL_POWER", "EXTERNAL_POWER", "",
    MENUTYPE_ACTIONSERIES,
    [
         [nil, "PA_MODE", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "EXTERNAL 50W PA MODE"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                nil, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil     // We've implemented dynamic button press handlers for static displays
            ],
            [
                ["ON", "BYPASS"],
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ],
            "pgm_pa_mode"
        ]/*,
        [nil, "RECIEVE_LNA", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "RECIEVE LNA"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                { if (GET_STATE("pgm_pa_mode") != "RECIEVE LNA") then { ["EXT_DEV"] call FUNC(changeMenu); }; }, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil     // We've implemented dynamic button press handlers for static displays
            ],
            [
                ["IN", "OUT"],
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ],
            "pgm_recieve_lna"
        ]*/
    ],
    [nil,
    nil],    // This will be called after every action within the action list
     // This will get called on series completion
    {
        // Set the current channel to the edited preset, and save the so-far-edited values
        ["EXT_DEV"] call FUNC(changeMenu);
        true
    },
    "EXT_DEV"
]] call FUNC(createMenu);

GVAR(PGM_NORM) = ["PGM_NORM", "PGM_NORM", "",
    MENUTYPE_LIST,
    [
        [nil, "NET", "", MENU_ACTION_SUBMENU, ["PGM_SELECT_NET"], nil ],
        [nil, "GENRL", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "EXCLBND", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
    ],
    nil
];
[GVAR(PGM_NORM)] call FUNC(createMenu);

[["PGM_SELECT_NET", "PGM_SELECT_NET", "",
    MENUTYPE_ACTIONSERIES,
    [
        [nil, "SELECT_NET", "",
            MENUTYPE_NUMBER,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "SELECT NET TO MODIFY"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1-%ch-name"],
                [ROW_SMALL_5, ALIGN_CENTER, "ENTER 01 TO 99"]
            ],
            [
                {
                    private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                    SCRATCH_SET(GVAR(currentRadioId),"menuNumber",_channelNumber+1);
                }, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil     // We've implemented dynamic button press handlers for static displays
            ],
            [
                1,  // min number/start default
                99,  // Max number
                2,    // Digit count
                [ROW_LARGE_3, 0, 1] // Highlighting cursor information
            ],
            "pgm_preset_number"
        ],
        [nil, "ACTIVE_IN_LIST", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "ACTIVE IN LIST?"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                nil, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil     // We've implemented dynamic button press handlers for static displays
            ],
            [
                ["YES", "NO"],
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ],
            "pgm_active_in_list"
        ],
        [nil, "PRESET_TYPE", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "PRESET TYPE"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                nil, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil     // We've implemented dynamic button press handlers for static displays
            ],
            [
                ["LOS", "UHF SATCOM", "SINCGARS FH", "HAVEQUICK"],
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ],
            "pgm_preset_waveform"
        ]
    ],
    [nil,
    nil],    // This will be called after every action within the action list
     // This will get called on series completion
    {
        // Set the current channel to the edited preset, and save the so-far-edited values
        private _channelNumber = GET_STATE("pgm_preset_number") - 1;
        private _activeInList = GET_STATE("pgm_active_in_list");
        //_channelDescription = [_channelDescription] call CBA_fnc_trim;

        ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;
        private _channels = GET_STATE("channels");
        private _channel = HASHLIST_SELECT(_channels,_channelNumber);

        //TRACE_3("Retrieving radio information",_channelNumber,_channel,_channels);
        switch _activeInList do {
            case 'YES': { _activeInList = true; };
            case 'NO': { _activeInList = false; };
            default { _activeInList = true; };
        };
        HASH_SET(_channel,"active",_activeInList);
        HASHLIST_SET(_channels,_channelNumber,_channel);

        SET_STATE("channels",_channels);

        SET_STATE("pgm_preset_number",0);
        SET_STATE("pgm_name",nil);
        SET_STATE("pgm_active_in_list",nil);

        ["PGM_NORM_LOS"] call FUNC(changeMenu);
        true
    },
    "PGM_NORM"
]] call FUNC(createMenu);

GVAR(PGM_NORM_LOS) = ["PGM_NORM_LOS", "PGM_NORM_LOS", "",
    MENUTYPE_LIST,
    [
        ["FREQ", "FREQ", "",
            MENUTYPE_ACTIONSERIES,
            [
                [nil, "RECEIVE FREQUENCY", "",
                    MENUTYPE_FREQUENCY,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "RECEIVE FREQUENCY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "30 MHz - 51.99999 MHz"]
                    ],
                    [
                        {
                            private _value = GET_RADIO_VALUE("frequencyRX");
                            SCRATCH_SET(GVAR(currentRadioId),"menuFrequency",_value);
                        }, // onEntry
                        nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                        nil     // We've implemented dynamic button press handlers for static displays
                    ],
                    [
                        30,  // min number/start default
                        599.9999,  // Max number
                        7,    // Digit count
                        [ROW_LARGE_3, 0, 1] // Highlighting cursor information
                    ],
                    "pgm_rx_freq"
                ],
                [nil, "TX FREQUENCY", "",
                    MENUTYPE_FREQUENCY,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "TRANSMIT FREQUENCY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "30 MHz - 51.99999 MHz"]
                    ],
                    [
                        {
                            private _value = GET_RADIO_VALUE("frequencyTX");
                            SCRATCH_SET(GVAR(currentRadioId),"menuFrequency",_value);
                        }, // onEntry
                        nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                        nil     // We've implemented dynamic button press handlers for static displays
                    ],
                    [
                        30,  // min number/start default
                        599.9999,  // Max number
                        7,    // Digit count
                        [ROW_LARGE_3, 0, 1] // Highlighting cursor information
                    ],
                    "pgm_tx_freq"
                ],
                [nil, "RECEIVE ONLY", "",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "RECEIVE ONLY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            private _value = GET_RADIO_VALUE("rxOnly");
                            if (_value) then {
                                SET_STATE("menuSelection",1);
                                SCRATCH_SET(GVAR(currentRadioId),"pgm_rx_only","YES");
                            };
                        },
                        nil,
                        nil,
                        nil,
                        nil
                    ],
                    [
                        ["NO", "YES"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_rx_only"
                ]
            ],
            [nil, nil],
            {
                // Set the current channel to the edited preset, and save the so-far-edited values
                private _channelType = GET_STATE("pgm_preset_type");
                private _rx = GET_STATE("pgm_rx_freq");
                private _tx = GET_STATE("pgm_tx_freq");
                private _rxOnly = SCRATCH_GET(GVAR(currentRadioId),"pgm_rx_only");
                if (_rxOnly == "YES") then { _rxOnly = true; } else { _rxOnly = false; };

                if (isNil "_rx" || isNil "_tx") exitWith { false };

                private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                private _channels = GET_STATE("channels");
                private _channel = HASHLIST_SELECT(_channels,_channelNumber);
                //TRACE_3("Retrieving radio information",_channelNumber,_channel,_channels);

                HASH_SET(_channel,"frequencyRX",_rx);
                HASH_SET(_channel,"frequencyTX",_tx);
                HASH_SET(_channel,"rxOnly",_rxOnly);

                HASHLIST_SET(_channels,_channelNumber,_channel);
                SET_STATE("channels",_channels);

                SET_STATE("pgm_tx_freq",nil);
                SET_STATE("pgm_rx_freq",nil);
                SET_STATE("pgm_rx_only",nil);
            }
        ],
        ["COMSEC", "COMSEC", "", 
            MENUTYPE_ACTIONSERIES,
            [
                [nil, "CRYPTO MODE", "",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "CRYPTO MODE"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            private _encryption = GET_RADIO_VALUE("encryption");
                            if (_encryption > 0) exitWith {
                                SET_STATE("menuSelection",1);
                            };
                        },
                        nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                        nil,
                        nil,
                        {
                            private _check = SCRATCH_GET(GVAR(currentRadioId),"pgm_encryption");
                            
                            if (_check == "NONE") then {
                                private _currentAction = GET_STATE("menuAction");
                                _currentAction = _currentAction + 1;
                                SET_STATE("menuAction",_currentAction);
                            };
                        } 
                    ],
                    [
                        ["NONE", "VINSON",  "KG84", "FASCINATOR"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_encryption"
                ],
                [nil, "ENCRYPTION KEY", "",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "ENCRYPTION KEY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            private _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                            private _tek = GET_RADIO_VALUE("TEK");
                            SET_STATE("menuSelection",_tek-1);
                        },
                        nil,
                        nil,
                        nil,
                        nil
                    ],
                    [
                        ["TEK01", "TEK02", "TEK03", "TEK04", "TEK05", "TEK06", "TEK07", "TEK08", "TEK09", "TEK10", "TEK11", "TEK12", "TEK13", "TEK14", "TEK15", "TEK16", "TEK17", "TEK18", "TEK19", "TEK20", "TEK21", "TEK22", "TEK23", "TEK24", "TEK25"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_tek"
                ]
            ],
            [nil,
            nil],    // This will be called after every action within the action list
             // This will get called on series completion
            {
                // Set the current channel to the edited preset, and save the so-far-edited values
                private _channelEncryption = SCRATCH_GET(GVAR(currentRadioId),"pgm_encryption");

                private _channelTEK = parseNumber (SCRATCH_GET_DEF(GVAR(currentRadioId),"pgm_tek","0") SELECT [3]);


                private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                private _channels = GET_STATE("channels");
                private _channel = HASHLIST_SELECT(_channels,_channelNumber);
                switch _channelEncryption do{
                    default{
                        HASH_SET(_channel,"trafficRate",16);
                        HASH_SET(_channel,"TEK",_channelTEK);
                    };
                    case 'NONE': {
                        HASH_SET(_channel,"TEK",1);
                    };
                };

                

                HASHLIST_SET(_channels,_channelNumber,_channel);
                SET_STATE("channels",_channels);

                SET_STATE("pgm_encryption",nil);
                SET_STATE("pgm_tek",nil);

            }
        ],
        ["DATA/VOC", "DATA/VOC", "", 
            MENUTYPE_ACTIONSERIES,
            [
                [nil, "VOICE MODE", "",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "VOICE MODE"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        nil,
                        nil,
                        nil
                    ],
                    [
                        ["CLEAR", "MODEM"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_voice_mode"
                ],
                [nil, "MODULATION", "",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "MODULATION"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                         {
                            private _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                            private _txTone = GET_RADIO_VALUE("modulation");
                            {
                                if (_txTone == _x) exitWith {
                                    SET_STATE("menuSelection",_forEachIndex);
                                };
                            } forEach _options;
                        },
                        nil,
                        nil,
                        nil,
                        {
                            private _check = SCRATCH_GET(GVAR(currentRadioId),"pgm_modulation");
                            if (_check == "AM") then {
                                private _currentAction = GET_STATE("menuAction");
                                _currentAction = _currentAction + 1;
                                SET_STATE("pgm_fmd","8.0");

                                SET_STATE("menuAction",_currentAction);
                            };
                        }
                    ],
                    [
                        ["AM", "FM"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_modulation"
                ],
                [nil, "FM DEVIATION", "",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "FM DEVIATION"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            private _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                            private _deviation = GET_RADIO_VALUE("deviation");
                            {
                                if (_deviation == parseNumber _x) exitWith {
                                    SET_STATE("menuSelection",_forEachIndex);
                                };
                            } forEach _options;
                        },
                        nil,
                        nil // We've implemented dynamic button press handlers for static displays
                    ],
                    [
                        ["8.0 kHz","6.5 kHz","5.0 kHz"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_deviation"
                ]
            ],
            [nil, nil],
            {
                 // Set the current channel to the edited preset, and save the so-far-edited values
                private _channelModulation = SCRATCH_GET(GVAR(currentRadioId),"pgm_modulation");
                private _channelDeviation = parseNumber SCRATCH_GET(GVAR(currentRadioId),"pgm_deviation");
                
                private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                private _channels = GET_STATE("channels");
                private _channel = HASHLIST_SELECT(_channels,_channelNumber);

                switch _channelModulation do{
                    case "AM": {
                        HASH_SET(_channel,"squelch",0);
                        HASH_SET(_channel,"CTCSSTx",0);
                        HASH_SET(_channel,"CTCSSRx",0);
                        HASH_SET(_channel,"optionCode",200);
                    };
                    case "FM": {
                        HASH_SET(_channel,"optionCode",201);
                    };
                };
                HASH_SET(_channel,"modulation",_channelModulation);
                HASH_SET(_channel,"deviation",_channelDeviation);

                HASHLIST_SET(_channels,_channelNumber,_channel);
                SET_STATE("channels",_channels);
                SET_STATE("pgm_modulation",nil);
                SET_STATE("pgm_deviation",nil);  
            }
        ],
        [nil, "SQ", "", MENU_ACTION_SUBMENU, ["SQ"], nil ],
        [nil, "PWR", "",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "TX POWER LEVEL"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1 WATTS"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    TRACE_1("Entering tx power","");
                    private _power = GET_RADIO_VALUE("power");
                    SET_STATE("menuSelection",7);

                    private _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                    {
                        private _powerInt = (parseNumber _x) * 1000;
                        TRACE_2("COMPARE",_powerInt,_power);
                        if (_powerInt == _power) exitWith {
                            TRACE_1("FOUND MATCH",_forEachIndex);
                            SET_STATE("menuSelection",_forEachIndex);
                        };
                    } forEach _options;
                }, // onEntry
                nil,
                nil,
                {
                    TRACE_1("Saving tx selection","");
                    // If we are not in user mode, just skip this menu item
                    private _options = MENU_SELECTION_DISPLAYSET(_this) select 0;
                    private _selection = GET_STATE("menuSelection");
                    private _value = (parseNumber (_options select _selection)) * 1000;

                    TRACE_2("",_selection,_value);

                    private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                    private _channels = GET_STATE("channels");
                    private _channel = HASHLIST_SELECT(_channels,_channelNumber);

                    HASH_SET(_channel,"power",_value);
                    TRACE_1("Set radio power",_value);
                    HASHLIST_SET(_channels,_channelNumber,_channel);
                    SET_STATE("channels",_channels);
                },
                nil,
                nil,
                nil
            ],
            [
                ["1", "1.3", "1.6", "2", "2.5", "3", "4", "5", "6.3", "8", "10", "13", "16", "20"],
                //["2", "2.6", "3.2", "5", "6.25", "10", "13", "16", "20", "25", "30", "35", "40", "50"] //APPROXIMATE VEHICLE
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ]
        ],
        [nil, "NAME", "",
            MENUTYPE_ALPHANUMERIC,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "CHANGE NET NAME"],
                [ROW_LARGE_3, ALIGN_LEFT, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "ENTER NAME"]
            ],
            [
                {
                    private _value = GET_RADIO_VALUE("name");
                    _value = (_value + CHANNEL_PADDING_STRING) select [0, CHANNEL_NAME_MAX_LENGTH]; // Make sure we have something at each editindex
                    SCRATCH_SET(GVAR(currentRadioId),"menuString",_value);
                },
                {
                    private _value = nil;
                    _value = GET_STATE_DEF("pgm_name","");
                    if (_value != "") then {
                        private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                        private _channels = GET_STATE("channels");
                        private _channel = HASHLIST_SELECT(_channels,_channelNumber);

                        HASH_SET(_channel,"name",_value);
                        HASHLIST_SET(_channels,_channelNumber,_channel);
                        SET_STATE("channels",_channels);
                    };
                },
                nil,
                nil,
                nil
            ],
            [
                CHANNEL_NAME_MAX_LENGTH, // Editable digits
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ],
            "pgm_name"
        ]
    ],
    nil
];
[GVAR(PGM_NORM_LOS)] call FUNC(createMenu);
