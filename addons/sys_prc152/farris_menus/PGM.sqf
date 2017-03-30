//#define DEBUG_MODE_FULL
#include "script_component.hpp"

#define GET_RADIO_VALUE(x) [x] call FUNC(CURRENT_RADIO_VALUE)
#define GET_CHANNEL_DATA() [] call FUNC(CURRENT_RADIO_CHANNEL);

FUNC(CURRENT_RADIO_VALUE) = {
    _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
    _channels = GET_STATE("channels");
    _channel = HASHLIST_SELECT(_channels, _channelNumber);
    _value = HASH_GET(_channel, (_this select 0));
    _value
};
FUNC(CURRENT_RADIO_CHANNEL) = {
    _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
    _channels = GET_STATE("channels");
    _channel = HASHLIST_SELECT(_channels, _channelNumber);
    _channel
};

GVAR(PGM) = ["PGM", "PGM", "PGM",
    MENUTYPE_LIST,
    [
        ["SYSTEM PRESETS", "SYSTEM PRESETS", "PGM-SYS PRESETS",
            MENUTYPE_LIST, [
                [nil, "SYSTEM PRESET CONFIG", nil, MENU_ACTION_SUBMENU, ["SYSTEM PRESET CONFIG"] ],
                [nil, "RESET SYSTEM PRESET", nil,  MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
                [nil, "SYSTEM SCAN CONFIG", nil,  MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
            ],
            nil
        ],
        ["RADIO CONFIG", "RADIO CONFIG", "PGM-RADIO",
            MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil
        ],
        ["VULOS CONFIG", "VULOS CONFIG", "PGM-VULOS",
            MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil
        ],
        ["SINCGARS CONFIG", "SINCGARS CONFIG", "PGM-SINCGARS",
            MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil
        ],
        ["HAVEQUICK II CONFIG", "HAVEQUICK II CONFIG", "PGM-HAVEQUICK",
            MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil
        ],
        ["P25 CONFIG", "P25 CONFIG", "PGM-P25",
            MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil
        ]
    ],
    nil
];
[GVAR(PGM)] call FUNC(createMenu);


[["SYSTEM PRESET CONFIG", "SYSTEM PRESET CONFIG", "PGM-SYS PRESETS-CFG",
    MENUTYPE_ACTIONSERIES,
    [
        [nil, "SYSTEM PRESET NUMBER", "PGM-SYS PRESETS-CFG",
            MENUTYPE_NUMBER,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "SYSTEM PRESET NUMBER"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1-%ch-description"],
                [ROW_SMALL_5, ALIGN_CENTER, "ENTER 01 TO 99"]
            ],
            [
                {
                    _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                    SCRATCH_SET(GVAR(currentRadioId), "menuNumber", _channelNumber+1);
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
        [nil, "PRESET DESCRIPTION", "PGM-SYS PRESETS-CFG",
            MENUTYPE_ALPHANUMERIC,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "PRESET DESCRIPTION"],
                [ROW_LARGE_3, ALIGN_LEFT, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "ENTER DESCRIPTION"]
            ],
            [
                {
                    _value = GET_RADIO_VALUE("description");
                    SCRATCH_SET(GVAR(currentRadioId), "menuString", _value);
                },
                nil,
                nil
            ],
            [
                20,    // Digit count
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ],
            "pgm_description"
        ],
        [nil, "PRESET WAVEFORM", "PGM-SYS PRESETS-CFG",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "PRESET WAVEFORM"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                nil, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil     // We've implemented dynamic button press handlers for static displays
            ],
            [
                ["VULOS", "SINCGARS", "HAVEQUICK", "HPW", "P25"],
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ],
            "pgm_preset_waveform"
        ]
    ],
    [nil,
    nil],    // This will be called after every action within the action list
     // This will get called on series completion
    {
        TRACE_1("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", _this);
        // Set the current channel to the edited preset, and save the so-far-edited values
        _channelNumber = GET_STATE("pgm_preset_number") - 1;
        _channelWaveform = GET_STATE("pgm_preset_waveform");
        _channelDescription = GET_STATE("pgm_description");
        _channelDescription = [_channelDescription] call CBA_fnc_trim;
        ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;
        _channels = GET_STATE("channels");
        _channel = HASHLIST_SELECT(_channels, _channelNumber);
        //TRACE_3("Retrieving radio information", _channelNumber, _channel, _channels);

        HASH_SET(_channel, "description", _channelDescription);
        //HASH_SET(_channel, "type", (["channelMode", _channelWaveform, 1] call FUNC(formatChannelValue)));
        HASH_SET(_channel, "type", "BASIC");
        
        HASHLIST_SET(_channels, _channelNumber, _channel);
        SET_STATE("channels", _channels);

        SET_STATE("pgm_preset_number", 0);
        SET_STATE("pgm_preset_waveform", nil);
        SET_STATE("pgm_description", nil);

        // Now move on to our inner PGM menu
        // Because this action series ends differently, we call out our change menu rather than
        // Let the action series handle backing us out.
        ["PGM PRESET"] call FUNC(changeMenu);

        true
    },
    "PGM"
]] call FUNC(createMenu);

GVAR(PGMChannelMenu) = ["PGM PRESET", "PGM PRESET", "PGM-SYS PRESETS-CFG",
    MENUTYPE_LIST,
    [
        ["RADIO OPTIONS", "RADIO OPTIONS", "",
            MENUTYPE_ACTIONSERIES,
            [
                [nil, "PRESET DESCRIPTION", "PGM-SYS PRESETS-CFG",
                    MENUTYPE_ALPHANUMERIC,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "PRESET DESCRIPTION"],
                        [ROW_LARGE_3, ALIGN_LEFT, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "ENTER DESCRIPTION"]
                    ],
                    [
                        {
                            _value = GET_RADIO_VALUE("description");
                            SCRATCH_SET(GVAR(currentRadioId), "menuString", _value);
                        }, // onEntry
                        nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                        nil     // We've implemented dynamic button press handlers for static displays
                    ],
                    [
                        20,    // Digit count
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_preset_description"
                ],
                [nil, "PRESET TYPE", "PGM-SYS PRESETS-CFG",
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
                        ["LOS", "SATCOM"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_preset_type"
                ]
            ],
            [nil,
            nil],    // This will be called after every action within the action list
             // This will get called on series completion
            {
                // Set the current channel to the edited preset, and save the so-far-edited values
                _channelType = GET_STATE("pgm_preset_type");
                _channelDescription = GET_STATE("pgm_preset_description");

                if (isNil "_channelType" || isNil "_channelDescription") exitWith {};

                _channelDescription = [_channelDescription] call CBA_fnc_trim;

                _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                _channels = GET_STATE("channels");
                _channel = HASHLIST_SELECT(_channels, _channelNumber);
                //TRACE_3("Retrieving radio information", _channelNumber, _channel, _channels);

                HASH_SET(_channel, "description", _channelDescription);
                HASH_SET(_channel, "type", _channelType);
                
                HASHLIST_SET(_channels, _channelNumber, _channel);
                SET_STATE("channels", _channels);

                SET_STATE("pgm_preset_type", nil);
                SET_STATE("pgm_preset_description", nil);
            }
        ],
        ["FREQUENCY", "FREQUENCY", "PGM-SYS PRESETS-CFG",
            MENUTYPE_ACTIONSERIES,
            [
                [nil, "RX FREQUENCY", "PGM-SYS PRESETS-CFG-RX",
                    MENUTYPE_FREQUENCY,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "RX FREQUENCY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "ENTER FERQUENCY"]
                    ],
                    [
                        {
                            _value = GET_RADIO_VALUE("frequencyRX");
                            SCRATCH_SET(GVAR(currentRadioId), "menuFrequency", _value);
                        }, // onEntry
                        nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                        nil     // We've implemented dynamic button press handlers for static displays
                    ],
                    [
                        0.0001,  // min number/start default
                        599.9999,  // Max number
                        8,    // Digit count
                        [ROW_LARGE_3, 0, 1] // Highlighting cursor information
                    ],
                    "pgm_rx_freq"
                ],
                [nil, "RX ONLY", "PGM-SYS PRESETS-CFG-RX",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "RECEIVE ONLY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        nil,
                        nil,
                        nil,
                        nil,
                        {
                            // If its RX only, zero out the TX frequency and
                            // Skip the rest of the menus
                            _menu = _this select 0;
                            _value = SCRATCH_GET_DEF(GVAR(currentRadioId), "pgm_rx_only", "NO");
                            if (_value == "YES") then {
                                //SCRATCH_SET(GVAR(currentRadioId), "pgm_tx_freq", 0.0);
                                _currentAction = GET_STATE("menuAction");
                                _currentAction = _currentAction + 2;
                                SET_STATE("menuAction", _currentAction);
                            };
                        }
                    ],
                    [
                        ["NO", "YES"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_rx_only"
                ],
                [nil, "TX_USE_RX", "PGM-SYS PRESETS-CFG-TX",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "TX FREQUENCY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        nil,
                        nil,
                        nil,
                        nil,
                        {
                            _value = SCRATCH_GET_DEF(GVAR(currentRadioId), "pgm_tx", "USE RX");
                            // If it is USE TX, we just skip the next menu action and it should finalize
                            if (_value == "USE RX") then {
                                _rx = GET_STATE_DEF("pgm_rx_freq", "0");
                                SET_STATE("pgm_tx_freq", _rx);
                                _currentAction = GET_STATE("menuAction");
                                _currentAction = _currentAction + 1;
                                SET_STATE("menuAction", _currentAction);
                            };
                        }
                    ],
                    [
                        ["USE RX", "EDIT TX"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_tx"
                ],
                [nil, "TX FREQUENCY", "PGM-SYS PRESETS-CFG-RX",
                    MENUTYPE_FREQUENCY,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "TX FREQUENCY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "ENTER FERQUENCY"]
                    ],
                    [
                        {
                            _value = GET_RADIO_VALUE("frequencyTX");
                            SCRATCH_SET(GVAR(currentRadioId), "menuFrequency", _value);
                        }, // onEntry
                        nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                        nil     // We've implemented dynamic button press handlers for static displays
                    ],
                    [
                        1,  // min number/start default
                        599999,  // Max number
                        6,    // Digit count
                        [ROW_LARGE_3, 0, 1] // Highlighting cursor information
                    ],
                    "pgm_tx_freq"
                ]
            ],
            [nil, nil],
            {
                // Set the current channel to the edited preset, and save the so-far-edited values
                _channelType = GET_STATE("pgm_preset_type");
                _rx = GET_STATE("pgm_rx_freq");
                _tx = GET_STATE("pgm_tx_freq");
                _rxOnly = SCRATCH_GET(GVAR(currentRadioId), "pgm_rx_only");
                if (_rxOnly == "YES") then { _rxOnly = true; } else { _rxOnly = false; };

                if (isNil "_rx" || isNil "_tx") exitWith {};

                _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                _channels = GET_STATE("channels");
                _channel = HASHLIST_SELECT(_channels, _channelNumber);

                TRACE_3("Retrieving radio information", _channelNumber, _channel, _channels);
                TRACE_3("Saving", _rx, _tx, _rxOnly);

                HASH_SET(_channel, "frequencyRX", _rx);
                HASH_SET(_channel, "frequencyTX", _tx);
                HASH_SET(_channel, "rxOnly", _rxOnly);

                HASHLIST_SET(_channels, _channelNumber, _channel);
                SET_STATE("channels", _channels);

                SET_STATE("pgm_tx_freq", nil);
                SET_STATE("pgm_rx_freq", nil);
                SET_STATE("pgm_rx_only", nil);
            }
        ],
        ["COMSEC", "COMSEC", "PGM-SYS PRESETS-CFG",
            MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil
        ],
        ["TRAFFIC", "TRAFFIC", "PGM-SYS PRESETS-CFG",
            MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil
        ],
        ["TX POWER", "TX POWER", "PGM-SYS PRESETS-CFG",
            MENUTYPE_ACTIONSERIES,
            [
                [nil, "TX POWER", "PGM-SYS PRESETS-TX POWER",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "TX POWER"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            _power = GET_RADIO_VALUE("power");

                            SCRATCH_SET(GVAR(currentRadioId), "pgm_tx_power", _power);
                            switch _power do {
                                case 5000: {
                                    SCRATCH_SET(GVAR(currentRadioId), "pgm_tx_select", "HIGH");
                                    SET_STATE("menuSelection", 0);
                                };
                                case 2000: {
                                    SCRATCH_SET(GVAR(currentRadioId), "pgm_tx_select", "MED");
                                    SET_STATE("menuSelection", 1);
                                };
                                case 250: {
                                    SCRATCH_SET(GVAR(currentRadioId), "pgm_tx_select", "LOW");
                                    SET_STATE("menuSelection", 2);
                                };
                                default {
                                    SCRATCH_SET(GVAR(currentRadioId), "pgm_tx_select", "USER");
                                    SET_STATE("menuSelection", 3);
                                };
                            };
                        }, // onEntry
                        nil,
                        nil,
                        nil,
                        {
                            // If we are not in user mode, just skip this menu item
                            _check = SCRATCH_GET_DEF(GVAR(currentRadioId), "pgm_tx_select", "HIGH");
                            if (_check != "USER") then {
                                _currentAction = GET_STATE("menuAction");
                                _currentAction = _currentAction + 1;
                                switch _check do {
                                    case 'HIGH': {
                                        SET_STATE("pgm_tx_power", 5000);
                                    };
                                    case 'MED': {
                                        SET_STATE("pgm_tx_power", 2000);
                                    };
                                    case 'LOW': {
                                        SET_STATE("pgm_tx_power", 250);
                                    };
                                };
                                SET_STATE("menuAction", _currentAction);
                            };
                        }
                    ],
                    [
                        ["HIGH", "MED", "LOW", "USER"],
                        [ROW_LARGE_3, 0, -1] // Highlighting cursor information
                    ],
                    "pgm_tx_select"
                ],
                [nil, "TX POWER USER", "PGM-SYS PRESETS-TX POWER",
                    MENUTYPE_NUMBER,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "TX POWER"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1 "],
                        [ROW_SMALL_5, ALIGN_CENTER, "ENTER 1 to 5000 MW"]
                    ],
                    [
                        {
                            _value = GET_RADIO_VALUE("power");
                            SCRATCH_SET(GVAR(currentRadioId), "menuNumber", _value);
                        },
                        nil
                    ],
                    [
                        1,  // min number/start default
                        5000,  // Max number
                        4,    // Digit count
                        [ROW_LARGE_3, 0, 1] // Highlighting cursor information
                    ],
                    "pgm_tx_power"
                ]
            ],
            [nil,
            nil],
            {
                // Save the new power.
                _power = GET_STATE_DEF("pgm_tx_power", 5000);
                _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                _channels = GET_STATE("channels");
                _channel = HASHLIST_SELECT(_channels, _channelNumber);

                if (_power > 5000) then {
                    _power = 5000;
                };
                HASH_SET(_channel, "power", _power);

                HASHLIST_SET(_channels, _channelNumber, _channel);
                SET_STATE("channels", _channels);


                SET_STATE("pgm_tx_power", nil);
            }
        ],
        ["SQUELCH", "SQUELCH", "PGM-SYS PRESETS-CFG",
            MENUTYPE_ACTIONSERIES,
            [
                [nil, "SQUELCH TYPE", "PGM-SYS PRESETS-SQUELCH",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "SQUELCH TYPE"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            _sqType = GET_RADIO_VALUE("squelch");
                            switch _sqType do {
                                default {

                                };
                                case 3: {
                                    SCRATCH_SET(GVAR(currentRadioId), "pgm_sq_tx_select", "CTCSS");
                                    SET_STATE("menuSelection", 1);
                                };
                            };
                        },
                        nil,
                        nil,
                        nil,
                        {
                            _sqType = SCRATCH_GET_DEF(GVAR(currentRadioId), "pgm_sq_tx_select", "CTCSS");
                            switch _sqType do {
                                default {        // Default is go to end, we only have 1 configurable SQ for now
                                    _currentAction = GET_STATE("menuAction");
                                    _currentAction = _currentAction + 999;
                                    SET_STATE("menuAction", _currentAction);
                                };
                                case 'CTCSS': {
                                    // Next menu is CTCSS
                                };
                            };
                        }
                    ],
                    [
                        ["DISABLED", "CTCSS", "CDCSS", "NOISE", "TONE"],
                        [ROW_LARGE_3, 0, -1]
                    ],
                    "pgm_sq_tx_select"
                ],
                [nil, "CTCSS_TONE", "PGM-SYS PRESETS-SQUELCH-CTCSS",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "CTCSS TX TONE"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            _options = MENU_SELECTION_DISPLAYSET(_this) select 0;

                            _txTone = GET_RADIO_VALUE("CTCSSTx");
                            {
                                if (_txTone == (parseNumber _x)) exitWith {
                                    SET_STATE("menuSelection", _forEachIndex);
                                };
                            } forEach _options;
                        },
                        nil,
                        nil,
                        nil,
                        {
                            //_sqTone = SCRATCH_GET_DEF(GVAR(currentRadioId), "pgm_sq_tx_ctcss_tone", "250.3");
                        }
                    ],
                    [
                        ["67.0", "69.3", "71.9", "74.4", "77.0", "79.7", "82.5", "85.4", "88.5", "91.5", "94.8", "97.4", "100.0", "103.5", "107.2", "110.9", "114.8", "118.8", "123.0", "127.3", "131.8", "136.5", "141.3", "146.2", "151.4", "156.7", "162.2", "167.9", "173.8", "179.9", "186.2", "192.8", "203.5", "206.5", "210.7", "218.1", "225.7", "229.1", "233.6", "241.8", "250.3", "254.1" ],
                        [ROW_LARGE_3, 0, -1]
                    ],
                    "pgm_sq_tx_ctcss_tone"
                ],
                [nil, "RX_SQUELCH_TYPE", "PGM-SYS PRESETS-SQUELCH-CTCSS",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "RX SQUELCH TYPE"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            SCRATCH_SET(GVAR(currentRadioId), "pgm_sq_rx_select", "CTCSS");
                            SET_STATE("menuSelection", 1);
                        },
                        nil,
                        nil,
                        nil,
                        {
                            //_sqTone = SCRATCH_GET_DEF(GVAR(currentRadioId), "pgm_sq_tx_ctcss_tone", "250.3");
                        }
                    ],
                    [
                        ["DISABLED", "CTCSS", "NOISE"],
                        [ROW_LARGE_3, 0, -1]
                    ],
                    "pgm_sq_rx_select"
                ],
                [nil, "CHAN_BUSY_PRIORITY", "PGM-SYS PRESETS-SQUELCH",
                    MENUTYPE_SELECTION,
                    [
                        [ROW_LARGE_2, ALIGN_CENTER, "CHAN BUSY PRIORITY"],
                        [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                        [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
                    ],
                    [
                        {
                            _sqType = SCRATCH_GET_DEF(GVAR(currentRadioId), "pgm_sq_tx_select", "CTCSS");
                            if (_sqType != "CTCSS" && _sqType != "CDCSS") then {
                                _currentAction = GET_STATE("menuAction");
                                _currentAction = _currentAction + 1;
                                SET_STATE("menuAction", _currentAction);
                            };
                        },
                        nil,
                        nil,
                        nil,
                        {
                        }
                    ],
                    [
                        ["TRANSMIT", "RECEIVE"],
                        [ROW_LARGE_3, 0, -1]
                    ],
                    "pgm_sq_chan_busy"
                ]
                // RX SQUELCH TYPE - DISABLED/CTCSS/NOISE
            ],
            [
                nil, nil, nil,nil
            ],
            {
                TRACE_1("Saving top level squelch information", "");

                _sqType = SCRATCH_GET_DEF(GVAR(currentRadioId), "pgm_sq_tx_select", "CTCSS");
                TRACE_1("SQUELCH TYPE", _sqType);
                switch _sqType do {
                    default { };
                    case 'CTCSS': {
                        _sqToneStr = SCRATCH_GET(GVAR(currentRadioId), "pgm_sq_tx_ctcss_tone");
                        _value = parseNumber _sqToneStr;
                        TRACE_3("Set squelch", _sqType, _sqToneStr, _value);


                        _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
                        _channels = GET_STATE("channels");
                        _channel = HASHLIST_SELECT(_channels, _channelNumber);

                        HASH_SET(_channel, "squelch", 3);
                        HASH_SET(_channel, "CTCSSTx", _value);
                        HASH_SET(_channel, "CTCSSRx", _value);

                        SET_STATE("channels", _channels);
                    };
                };
            }
        ],
        ["EXIT", "EXIT", "PGM-SYS PRESETS-CFG", MENU_ACTION_SUBMENU, ["HOME"], [], nil ]
    ],
    [
        nil, nil, nil,nil
    ]
];
[GVAR(PGMChannelMenu)] call FUNC(createMenu);
