//#define DEBUG_MODE_FULL
#include "script_component.hpp"

DFUNC(onButtonPress_Display) = {
    TRACE_1("onButtonPress_Display", _this);
    params["_menu", "_event"];

    _currentSelection = GET_STATE_DEF("menuSelection", 0);
    switch (_event select 0) do {
        case 'PRE_UP': {     // OPT
            BEGIN_COUNTER(onButtonPress_Display_PRE_UP);
            
            BEGIN_COUNTER(onButtonPress_Display_GuiEvents);
            
            _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
            _channels = GET_STATE("channels");
            if(_channelNumber < 98) then {
                _channelNumber = _channelNumber + 1;
            } else {
                _channelNumber = 0;
            };
            ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;
            
            END_COUNTER(onButtonPress_Display_GuiEvents);
            
            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call CALLSTACK(FUNC(renderMenu_Static));
            
            END_COUNTER(onButtonPress_Display_PRE_UP);
        };
        case 'PRE_DOWN': { // PGM
            BEGIN_COUNTER(onButtonPress_Display_PRE_DOWN);
            
            BEGIN_COUNTER(onButtonPress_Display_GuiEvents);
            
            _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;
            _channels = GET_STATE("channels");
            if(_channelNumber > 0) then {
                _channelNumber = _channelNumber - 1;
            } else {
                // Go to the last preset 
                _channelNumber = 98;
            };
            ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;
            
            END_COUNTER(onButtonPress_Display_GuiEvents);
            
            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call CALLSTACK(FUNC(renderMenu_Static));
            
            END_COUNTER(onButtonPress_Display_PRE_DOWN);
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
            
            if(_currentSelection+1 >= (count MENU_SUBMENUS(_menu))) then {
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
    BEGIN_COUNTER(renderMenu_Display);
    
    private["_format", "_renderString"];
    TRACE_1("renderMenu_Display", _this);
    params["_menu"]; // the menu to render is passed
    _displaySet = MENU_SUBMENUS(_menu);

    
    _currentSelection = GET_STATE_DEF("menuSelection", 0);
    _currentDisplay = MENU_SUBMENUS_ITEM(_menu,_currentSelection);
        
    // A display set has a set of children STATIC displays, which are rendered and canFire
    // be swaped with the 'NEXT' circly button thingy
    _entry = SCRATCH_GET_DEF(GVAR(currentRadioId), "menuEntry", false);
    if(_entry) then {
        [_currentDisplay] call FUNC(callEntryFunctor);
    };
    
    [_currentDisplay, _menu] call FUNC(renderMenu);
    
    END_COUNTER(renderMenu_Display);
};
