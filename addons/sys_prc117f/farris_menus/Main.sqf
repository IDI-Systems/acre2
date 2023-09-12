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

GVAR(OFF) = ["OFF", "OFF", "", MENUTYPE_STATIC, [],[ nil,nil, nil ] ];
[GVAR(OFF)] call FUNC(createMenu);

GVAR(INVALID_MODE) = ["INVALID_MODE", "INVALID_MODE", "",
    MENUTYPE_STATIC,
    [
        //[ROW_SMALL_1, ALIGN_LEFT, "$transmitting $bat         $cch-channelmode $cch-squelch ----- $cch-encryption"],
        [ROW_XLARGE_1, ALIGN_LEFT, "INVALID MODE"],
        [ROW_LARGE_3, ALIGN_LEFT, "ONLY PT SUPPORTED"]
    ],
    [
        nil, // onEntry
        nil, // onExit
        nil
    ]
];
[GVAR(INVALID_MODE)] call FUNC(createMenu);

GVAR(NoItems) = ["ERROR_NOENTRY", "ERROR_NOENTRY", "",
    MENUTYPE_STATIC,
    [
        [ROW_SMALL_1, ALIGN_LEFT, "$transmitting $bat      $cch-channelmode              $cch-encryption"],
        [ROW_LARGE_2, ALIGN_LEFT, "<NO ITEMS IN MENU>"],
        [ROW_SMALL_5, ALIGN_CENTER, "ENT OR CLR TO CONT"]
    ],
    [
        {

        }, // onEntry
        nil, // onExit
        {
            TRACE_1("ERROR_NOENTRY:onButtonPress", (_this select 1));
            if (((_this select 1) select 0) == "ENT" || ((_this select 1) select 0) == "CLR") then {
                TRACE_1("BACK TO HOME", "");
                private _home = GET_STATE_DEF("currentHome", GVAR(VULOSHOME));
                [_home] call FUNC(changeMenu);
            };
            true
        }
    ]
];
[GVAR(NoItems)] call FUNC(createMenu);

GVAR(NOT_IMPLEMENTED) = ["NOT_IMPLEMENTED", "NOT_IMPLEMENTED", "",
    MENUTYPE_STATIC,
    [
        [ROW_LARGE_2, ALIGN_CENTER, "NOT IMPLEMENTED YET"]
    ],
    [
        {

        }, // onEntry
        nil, // onExit
        {
            TRACE_1("ERROR_NOENTRY:onButtonPress", (_this select 1));
            if (((_this select 1) select 0) == "ENT" || ((_this select 1) select 0) == "CLR") then {
                TRACE_1("BACK TO HOME", "");
                private _home = GET_STATE_DEF("currentHome", GVAR(VULOSHOME));
                [_home] call FUNC(changeMenu);
            };
            true
        }
    ]
];
[GVAR(NOT_IMPLEMENTED)] call FUNC(createMenu);


GVAR(VOLUME) = ["VOLUME", "VOLUME", "",
    MENUTYPE_STATIC,
    [
        [ROW_SMALL_1, ALIGN_LEFT, "$transmitting VOL         $cch-channelmode $cch-squelch ----- $cch-encryption"],
        [ROW_LARGE_2, ALIGN_CENTER, "VOLUME"]
    ],
    [
        nil,nil,nil,
        {

//            [ICON_BATTERY, false] call DFUNC(toggleIcon);
            [ICON_LOADING, true] call DFUNC(toggleIcon);
            private _volume = GET_STATE("volume");

            private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];

            TRACE_2("Rendering VOLUME-STAGE-1",_volume, _display);
            if (!isNull _display) then {
                (_display displayCtrl ICON_LOADING) progressSetPosition _volume;
                (_display displayCtrl ICON_LOADING) ctrlCommit 0;
            };
        }
    ]
];
[GVAR(VOLUME)] call FUNC(createMenu);

GVAR(VULOSHOME) = ["VULOSHOME", "VULOSHOME", "",
    MENUTYPE_DISPLAY,
    [
        ["VULOSHOME-MAIN", "VULOSHOME-MAIN", "",
            MENUTYPE_STATIC,
            [
                [ROW_SMALL_1, ALIGN_LEFT, "$transmitting $bat      $cch-channelmode              $cch-encryption"],
                [ROW_LARGE_2, ALIGN_LEFT, "$cch-number-$cch-name"],
                [ROW_LARGE_3, ALIGN_LEFT, "LOS  VOC  OFF $cch-modulation   $cch-squelch"],
                [ROW_SMALL_5, ALIGN_LEFT, "TYPE    ADF   DATA  MOD     SQL"]
            ],
            [
                nil,
                nil,
                nil,
                {
                    [ICON_BATTERY, false] call FUNC(toggleIcon);
                    [ICON_VOLUME, true] call FUNC(toggleIcon);
                    [ICON_TRANSMITBAR, true] call FUNC(toggleIcon);
                    //[ICON_TRANSMIT, true] call FUNC(toggleIcon);

                    private _volume = GET_STATE("volume");
                    private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
                    private _recStrength = SCRATCH_GET_DEF(GVAR(currentRadioID), "receivingSignal", 0);

                    TRACE_2("Rendering VOLUME-STAGE-1",_volume, _display);
                    if (!isNull _display) then {
                        (_display displayCtrl ICON_VOLUME) progressSetPosition _volume;
                        (_display displayCtrl ICON_VOLUME) ctrlCommit 0;
                        (_display displayCtrl ICON_TRANSMITBAR) progressSetPosition _recStrength;
                        (_display displayCtrl ICON_TRANSMITBAR) ctrlCommit 0;
                    };
                }
            ]
        ],
        ["VULOSHOME-CHANNEL", "VULOSHOME-CHANNEL", "",
            MENUTYPE_STATIC,
            [
                [ROW_SMALL_1, ALIGN_LEFT, "$transmitting $bat         $cch-channelmode $cch-squelch ----- $cch-encryption"],
                [ROW_LARGE_2, ALIGN_LEFT, "R: $cch-frequencyrx"],
                [ROW_LARGE_3, ALIGN_LEFT, "T: $cch-frequencytx              $cch-trafficrate "],
                [ROW_SMALL_5, ALIGN_LEFT, " FREQUENCY            RATE"]
            ],
            [
                nil, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil,
                {
                    //[ICON_BATTERY, false] call FUNC(toggleIcon);
                    [ICON_VOLUME, true] call FUNC(toggleIcon);
                    [ICON_TRANSMITBAR, true] call FUNC(toggleIcon);
                    //[ICON_TRANSMIT, true] call FUNC(toggleIcon);
                    private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
                    private _recStrength = SCRATCH_GET_DEF(GVAR(currentRadioID), "receivingSignal", 0);

                    TRACE_2("Rendering VOLUME-STAGE-1",_volume, _display);
                    if (!isNull _display) then {
                        (_display displayCtrl ICON_TRANSMITBAR) progressSetPosition _recStrength;
                        (_display displayCtrl ICON_TRANSMITBAR) ctrlCommit 0;
                    };
                }
            ]
        ],
        ["VULOSHOME-DATA", "VULOSHOME-DATA", "",
            MENUTYPE_STATIC,
            [
                [ROW_SMALL_1, ALIGN_LEFT, "$transmitting $bat         $cch-channelmode $cch-squelch ----- $cch-encryption"],
                [ROW_LARGE_2, ALIGN_LEFT, "--- -----   --"],
                [ROW_LARGE_3, ALIGN_LEFT, "$cch-optioncode ---- ANLG --   OFF"],
                [ROW_SMALL_5, ALIGN_LEFT, "OPT   DATA   VOICE  INTLV   FEC"]
            ],
            [
                nil, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil,
                {
                    //[ICON_BATTERY, false] call FUNC(toggleIcon);
                    [ICON_VOLUME, true] call FUNC(toggleIcon);
                    [ICON_TRANSMITBAR, true] call FUNC(toggleIcon);
                    //[ICON_TRANSMIT, true] call FUNC(toggleIcon);
                    private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
                    private _recStrength = SCRATCH_GET_DEF(GVAR(currentRadioID), "receivingSignal", 0);

                    TRACE_2("Rendering VOLUME-STAGE-1",_volume, _display);
                    if (!isNull _display) then {
                        (_display displayCtrl ICON_TRANSMITBAR) progressSetPosition _recStrength;
                        (_display displayCtrl ICON_TRANSMITBAR) ctrlCommit 0;
                    };
                }
            ]
        ],
        ["VULOSHOME-LARGEFONT", "VULOSHOME-LARGEFONT", "",
            MENUTYPE_STATIC,
            [
                [ROW_SMALL_1, ALIGN_LEFT, "$transmitting $bat         $cch-channelmode $cch-squelch ----- $cch-encryption"],
                [ROW_XLARGE_2, ALIGN_LEFT, "$cch-number*$cch-name"]
            ],
            [
                nil, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                nil,
                {
                    //[ICON_BATTERY, false] call FUNC(toggleIcon);
                    [ICON_VOLUME, true] call FUNC(toggleIcon);
                    //[ICON_TRANSMIT, true] call FUNC(toggleIcon);
                }
            ]
        ]
    ],
    nil
];
[GVAR(VULOSHOME)] call FUNC(createMenu);
