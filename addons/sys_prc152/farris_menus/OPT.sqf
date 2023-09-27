#include "..\script_component.hpp"

GVAR(OptRadioOptions) = ["RADIO_OPTIONS", "RADIO OPTIONS", "OPT-RADIO",
    MENUTYPE_LIST,
    [
        [nil, "SATCOM BURST MODE", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "RADIO SILENCE SCREEN", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "RADIO SPEAKER", "OPT-RADIO-SPEAKER",
            MENUTYPE_SELECTION,
            [
                [ROW_LARGE_2, ALIGN_CENTER, "RADIO SPEAKER"],
                [ROW_LARGE_3, ALIGN_CENTER, "%1"],
                [ROW_SMALL_5, ALIGN_CENTER, "^ TO SCROLL / ENT TO CONT"]
            ],
            [
                {
                    private _value = GET_STATE("audioPath");
                    //diag_log text format["render: %1", _value];
                    if (_value == "INTAUDIO") then {
                        SCRATCH_SET(GVAR(currentRadioId), "opt_radio_speaker", "ON");
                        SET_STATE("menuSelection", 1);
                    };
                },
                {
                    //diag_log text format["save!"];
                    // If its RX only, zero out the TX frequency and
                    // Skip the rest of the menus
                    private _menu = _this select 0;
                    private _value = SCRATCH_GET_DEF(GVAR(currentRadioId), "opt_radio_speaker", "OFF");
                    if (_value == "ON") then {
                        //diag_log text format["ON!!!!!!!"];
                        SET_STATE("audioPath", "INTAUDIO");
                    } else {
                        SET_STATE("audioPath", "TOPAUDIO");
                    };
                },nil,nil
            ],
            [
                ["OFF", "ON"],
                [ROW_LARGE_3, 0, -1] // Highlighting cursor information
            ],
            "opt_radio_speaker"
        ],
        [nil, "AUXILIARY POWER", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "PRESET AUTOSAVE", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "RF FAULTS PERSIST", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
    ],
    nil
];
[GVAR(OptRadioOptions)] call FUNC(createMenu);


GVAR(OptTxOptions) = ["TX_POWER_OPTIONS", "TX POWER OPTIONS", "OPT-TX",
    MENUTYPE_LIST,
    [
        [nil, "ACCESS DENIED", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
    ],
    nil
];
[GVAR(OptTxOptions)] call FUNC(createMenu);


GVAR(OPT) = ["OPT", "OPT", "OPT",
    MENUTYPE_LIST,
    [
        // TODO: Locks all but next. 1,3,7,9 series unlocks. Display "Keypad is Locked"
        [nil, "LOCK KEYPAD", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "RADIO OPTIONS", "", MENU_ACTION_SUBMENU, ["RADIO_OPTIONS"], nil ],
        [nil, "WAVEFORM OPTIONS", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "TX POWER OPTIONS", "", MENU_ACTION_SUBMENU, ["TX_POWER_OPTIONS"], nil ],
        [nil, "SYSTEM CLOCK", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "GPS OPTIONS", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "BATTERY INFORMATION", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "SA OPTIONS", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "DATA MODE", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "MISSION PLAN", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "NETWORK STATUS", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "SYSTEM INFORMATION", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "TEST OPTIONS", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
        [nil, "VIEW KEY INFO", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
    ],
    nil
];
[GVAR(OPT)] call FUNC(createMenu);
