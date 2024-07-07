#include "..\script_component.hpp"
//#define DEBUG_MODE_FULL

DFUNC(Loading_End) = {
    params ["_radioId"];
    // Turn the radio on
    [_radioId, "setOnOffState", 1] call EFUNC(sys_data,dataEvent);

    if (_radioId isEqualTo GVAR(currentRadioId)) then {
        [GVAR(LOADING), ["0"]] call DFUNC(onButtonPress_Display);
    };
};

DFUNC(Loading_BarFill) = {

    if (isNil QGVAR(currentBarFill)) then { GVAR(currentBarFill) = 0.0; };
    GVAR(currentBarFill) = GVAR(currentBarFill) + 0.05;

    private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
    if (!isNull _display) then {
        (_display displayCtrl ICON_LOADING) progressSetPosition GVAR(currentBarFill);
        (_display displayCtrl ICON_LOADING) ctrlCommit 0;
    };
};

DFUNC(Loading_BarFill_end) = {
    params ["_radioId"];
    // Turn the radio on
    [_radioId, "setOnOffState", 1] call EFUNC(sys_data,dataEvent);
    if (_radioId isEqualTo GVAR(currentRadioId)) then {
        private _currentMenu = GET_STATE_DEF("currentHome",GVAR(VULOSHOME));
        [_currentMenu] call FUNC(changeMenu);
    };
};

GVAR(LOADING) = ["LOADING", "LOADING", "",
    MENUTYPE_DISPLAY,
    [
        ["LOADING-STAGE-1", "LOADING-STAGE-1", "",
            MENUTYPE_STATIC,
            [
                [ROW_SMALL_1, ALIGN_LEFT, ""],
                [ROW_LARGE_2, ALIGN_LEFT, ""],
                [ROW_LARGE_3, ALIGN_LEFT, ""],
                [ROW_SMALL_5, ALIGN_LEFT, ""]
            ],
            [
                {
                    private _radioId = GVAR(currentRadioId);
                    // Turn the radio on
                    [_radioId, "setOnOffState", 0.5] call EFUNC(sys_data,dataEvent);

                    TRACE_1("Registering function","");
                    [GVAR(currentRadioId), DFUNC(Loading_End), 3] call DFUNC(delayFunction);
                }, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                { true },
                {
                    TRACE_1("Rendering LOADING-STAGE-1","");
                    [ICON_LOGO, true] call DFUNC(toggleIcon);
                }
            ]
        ],
        ["LOADING-STAGE-2", "LOADING-STAGE-2", "",
            MENUTYPE_STATIC,
            [
                [ROW_LARGE_1, ALIGN_CENTER, "IDI SYSTEMS"],
                [ROW_LARGE_2, ALIGN_CENTER, ".. INITIALIZING .."],
                [ROW_LARGE_3, ALIGN_CENTER, ""],
                [ROW_SMALL_5, ALIGN_CENTER, "Bueller II FIrmware"]
            ],
            [
                nil, // onEntry
                nil,  // onExit. Our parent static display generic event handler handles the 'Next' key
                { true },
                {
                    TRACE_1("Rendering LOADING-STAGE-2","");
                    GVAR(currentBarFill) = 0;
                    [ICON_LOADING, true] call DFUNC(toggleIcon);
                    private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
                    if (!isNull _display) then {
                        (_display displayCtrl ICON_LOADING) progressSetPosition 0.0;
                        (_display displayCtrl ICON_LOADING) ctrlCommit 0;
                    };
                    [GVAR(currentRadioId), DFUNC(Loading_BarFill_End), 5.25] call DFUNC(delayFunction);
                    [GVAR(currentRadioId), DFUNC(Loading_BarFill), 0.25, 5] call DFUNC(timerFunction);
                }
            ]
        ]
    ],
    nil
];
[GVAR(VULOSHOME)] call FUNC(createMenu);
