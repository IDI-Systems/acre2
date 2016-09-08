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

#include "\idi\acre\addons\sys_prc148\script_component.hpp"

DFUNC(GroupDisplay_Render) = {
    _groups = GET_STATE(groups);
    _options = [];
    _labels = [];
    SET_TEXT("GROUP =", BIG_LINE_3, 4, 10);
    {
        _x params ["_label", "_channels"];
        if((count _channels) > 0) then {
            PUSH(_labels, _label);
            PUSH(_options, _forEachIndex);
        };

    } forEach _groups;

    GVAR(currentMenu) =
    [
        [
            ["groupSelect", GET_STATE_DEF(currentGroup, 0), BIG_LINE_3, [12, 14], MENU_TYPE_LIST, FUNC(GroupDisplay_Select), _labels, _options]
        ]
    ];

    [_display, GVAR(currentMenu)] call FUNC(showMenu);
};

DFUNC(GroupDisplay_ESC) = {
    [GVAR(currentRadioId), "DefaultDisplay"] call FUNC(changeState);
};

DFUNC(GroupDisplay_Select) = {
    params["_newValue", "_menuEntry"];

    //diag_log text format["new: %1", _newValue];
    _newGroup = (_menuEntry select 7) select _newValue;
    SET_STATE_CRIT(currentGroup, _newGroup);

    _group = GET_STATE(groups) select GET_STATE(currentGroup);
    _channelPosition = GET_STATE(channelKnobPosition);



    if(_channelPosition > (count (_group select 1))-1) then {
        _channelPosition = (count (_group select 1))-1;
    };



    _channelNumber = (_group select 1) select _channelPosition;
    ["setCurrentChannel", _channelNumber] call GUI_DATA_EVENT;
    [GVAR(currentRadioId), "DefaultDisplay"] call FUNC(changeState);
};
