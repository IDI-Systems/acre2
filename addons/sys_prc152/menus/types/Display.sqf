#include "..\..\script_component.hpp"
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

DFUNC(onButtonPress_Display) = {
    TRACE_1("onButtonPress_Display", _this);
    params ["_menu", "_event"];

    private _currentSelection = GET_STATE_DEF("menuSelection", 0);
    switch (_event select 0) do {
        case 'PRE_UP': {     // OPT

            #ifdef ENABLE_PERFORMANCE_COUNTERS
                BEGIN_COUNTER(onButtonPress_Display_PRE_UP);
                BEGIN_COUNTER(onButtonPress_Display_GuiEvents);
            #endif

            private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
            private _channels = GET_STATE("channels");
            if (_channelNumber < 98) then {
                _channelNumber = _channelNumber + 1;
            } else {
                _channelNumber = 0;
            };
            ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;

            #ifdef ENABLE_PERFORMANCE_COUNTERS
                END_COUNTER(onButtonPress_Display_GuiEvents);
            #endif

            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call CALLSTACK(FUNC(renderMenu_Static));

            #ifdef ENABLE_PERFORMANCE_COUNTERS
                END_COUNTER(onButtonPress_Display_PRE_UP);
            #endif
        };
        case 'PRE_DOWN': { // PGM
            #ifdef ENABLE_PERFORMANCE_COUNTERS
                BEGIN_COUNTER(onButtonPress_Display_PRE_DOWN);
                BEGIN_COUNTER(onButtonPress_Display_GuiEvents);
            #endif

            private _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
            private _channels = GET_STATE("channels");
            if (_channelNumber > 0) then {
                _channelNumber = _channelNumber - 1;
            } else {
                // Go to the last preset
                _channelNumber = 98;
            };
            ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;

            #ifdef ENABLE_PERFORMANCE_COUNTERS
                END_COUNTER(onButtonPress_Display_GuiEvents);
            #endif

            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call CALLSTACK(FUNC(renderMenu_Static));

            #ifdef ENABLE_PERFORMANCE_COUNTERS
                END_COUNTER(onButtonPress_Display_PRE_DOWN);
            #endif
        };
        case '7': {     // OPT
            ["OPT"] call FUNC(changeMenu);
        };
        case '8': { // PGM
            ["PGM"] call FUNC(changeMenu);
        };
        case '0': {
            TRACE_2("Cycling display", _currentSelection, (count MENU_SUBMENUS(_menu)));
            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call FUNC(callCompleteFunctor);

            if (_currentSelection+1 >= (count MENU_SUBMENUS(_menu))) then {
                _currentSelection = 0;
            } else {
                _currentSelection = _currentSelection + 1;
            };

            SET_STATE("menuSelection", _currentSelection);
            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call FUNC(callEntryFunctor);
            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call FUNC(renderMenu_Static);
        };
        default {
            // Pass the button press along to the child menu
            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call FUNC(onButtonPress_Static);
        };
    };

    false
};

DFUNC(renderMenu_Display) = {
    #ifdef ENABLE_PERFORMANCE_COUNTERS
        BEGIN_COUNTER(renderMenu_Display);
    #endif

    TRACE_1("renderMenu_Display", _this);
    params ["_menu"]; // the menu to render is passed
    private _displaySet = MENU_SUBMENUS(_menu);


    private _currentSelection = GET_STATE_DEF("menuSelection", 0);
    private _currentDisplay = MENU_SUBMENUS_ITEM(_menu,_currentSelection);

    // A display set has a set of children STATIC displays, which are rendered and canFire
    // be swaped with the 'NEXT' circly button thingy
    private _entry = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuEntry", false);
    if (_entry) then {
        [_currentDisplay] call FUNC(callEntryFunctor);
    };

    [_currentDisplay, _menu] call FUNC(renderMenu);

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        END_COUNTER(renderMenu_Display);
    #endif
};
