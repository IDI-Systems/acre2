/*
 * Author: AUTHOR
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

DFUNC(onButtonPress_Display) = {
    private["_active", "_channelNumber", "_channel", "_currentSelection"];

    TRACE_1("onButtonPress_Display", _this);
    params["_menu", "_event"];

    _currentSelection = GET_STATE_DEF("menuSelection", 0);
    switch (_event select 0) do {
        case 'PRE_UP': {     // OPT
            _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;

            _active = false;
            while { !_active } do {
                if(_channelNumber < 98) then {
                    _channelNumber = _channelNumber + 1;
                } else {
                    _channelNumber = 0;
                };
                _channel = [GVAR(currentRadioId), _channelNumber] call FUNC(getChannelDataInternal);
                _active = HASH_GET(_channel, "active");
            };


            ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;
            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call CALLSTACK(FUNC(renderMenu_Static));
        };
        case 'PRE_DOWN': { // PGM
            _channelNumber = ["getCurrentChannel"] call GUI_DATA_EVENT;

            _active = false;
            while { !_active } do {
                if(_channelNumber > 0) then {
                    _channelNumber = _channelNumber - 1;
                } else {
                    _channelNumber = 98;
                };
                _channel = [GVAR(currentRadioId), _channelNumber] call FUNC(getChannelDataInternal);
                _active = HASH_GET(_channel, "active");
            };

            ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;
            [MENU_SUBMENUS_ITEM(_menu, _currentSelection)] call CALLSTACK(FUNC(renderMenu_Static));
        };
        case '4': {     // SQ
            ["SQ"] call FUNC(changeMenu);
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
    private["_displaySet", "_currentSelection", "_currentDisplay", "_entry"];
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

};
