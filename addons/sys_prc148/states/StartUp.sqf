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

DFUNC(PostScreen_Render) = {
    params["_display"];

    [_display, BIG_LINE_3, "TESTING", CENTER_ALIGN] call FUNC(displayLine);
    SCRATCH_SET(GVAR(currentRadioId), "post_animation_step", 0);
    [FUNC(PostScreen_Animation), []] call FUNC(addAnimation);

};

DFUNC(PostScreen_Animation) = {
    params["_args","_id"];

    _step = SCRATCH_GET_DEF(GVAR(currentRadioId), "post_animation_step", 0);
    if(_step == 0) then {
        [_display, SMALL_LINE_1, [1,25], false] call FUNC(highlightText);
        [_display, SMALL_LINE_5, [1,25], false] call FUNC(highlightText);

        [_display, SMALL_LINE_1, [12,13]] call FUNC(highlightText);
        [_display, SMALL_LINE_5, [12,13]] call FUNC(highlightText);
    } else {
        _stepLeft = 12-(_step*2);
        [_display, SMALL_LINE_1, [_stepLeft,_stepLeft]] call FUNC(highlightText);
        [_display, SMALL_LINE_5, [_stepLeft,_stepLeft]] call FUNC(highlightText);

        _stepRight = 13+(_step*2);
        [_display, SMALL_LINE_1, [_stepRight,_stepRight]] call FUNC(highlightText);
        [_display, SMALL_LINE_5, [_stepRight,_stepRight]] call FUNC(highlightText);
    };
    if(_step == 5) then {
        SCRATCH_SET(GVAR(currentRadioId), "post_animation_step", 0);
    } else {
        SCRATCH_SET(GVAR(currentRadioId), "post_animation_step", _step+1);
    };
};

DFUNC(PostScreen_End) = {
    params["_radioId"];

    _onState = [_radioId, "getOnOffState"] call EFUNC(sys_data,dataEvent);
    if(_onState > 0) then {
        [_radioId, "LogoScreen"] call FUNC(changeState);
        [_radioId, FUNC(LogoScreen_End), 3] call FUNC(delayFunction);
    };
};

DFUNC(LogoScreen_Render) = {
    [_display, BIG_LINE_2, "IDI-SYSTEMS", CENTER_ALIGN] call FUNC(displayLine);
    [_display, BIG_LINE_4, QUOTE(VERSION_PLUGIN), CENTER_ALIGN] call FUNC(displayLine);
    [FUNC(LogoScreen_Animation), []] call FUNC(addAnimation);
};

DFUNC(LogoScreen_Animation) = {
    params["_args","_id"];

    _step = SCRATCH_GET_DEF(GVAR(currentRadioId), "logo_animation_step", 0);
    if(_step == 0) then {
        [_display, SMALL_LINE_1, [1,25], false] call FUNC(highlightText);
        [_display, SMALL_LINE_2, [1,25], false] call FUNC(highlightText);
        [_display, SMALL_LINE_3, [1,25], false] call FUNC(highlightText);
        [_display, SMALL_LINE_4, [1,25], false] call FUNC(highlightText);
        [_display, SMALL_LINE_5, [1,25], false] call FUNC(highlightText);

        [_display, BIG_LINE_1, [1,18], false] call FUNC(highlightText);
        [_display, BIG_LINE_2, [1,18], false] call FUNC(highlightText);
        [_display, BIG_LINE_3, [1,18], false] call FUNC(highlightText);
        [_display, BIG_LINE_4, [1,18], false] call FUNC(highlightText);
    } else {
        switch _step do {
            case 1: {
                //[_display, BIG_LINE_1, [1,18], true] call FUNC(highlightText);
                [_display, SMALL_LINE_1, [1,25], true] call FUNC(highlightText);
            };
            case 2: {
                //[_display, BIG_LINE_2, [1,18], true] call FUNC(highlightText);
                [_display, SMALL_LINE_2, [1,25], true] call FUNC(highlightText);
            };
            case 3: {
                //[_display, BIG_LINE_3, [1,18], true] call FUNC(highlightText);
                [_display, SMALL_LINE_3, [1,25], true] call FUNC(highlightText);
            };
            case 4: {
                //[_display, BIG_LINE_4, [1,18], true] call FUNC(highlightText);
                [_display, SMALL_LINE_4, [1,25], true] call FUNC(highlightText);
            };
            case 5: {
                [_display, SMALL_LINE_5, [1,25], true] call FUNC(highlightText);
            };
        };
    };
    if(_step <= 5) then {
        SCRATCH_SET(GVAR(currentRadioId), "logo_animation_step", _step+1);
    };
};


DFUNC(LogoScreen_End) = {
    params["_radioId"];

    _onState = [_radioId, "getOnOffState"] call EFUNC(sys_data,dataEvent);
    if(_onState > 0) then {
        [_radioId, "setOnOffState", 1] call EFUNC(sys_data,dataEvent);
        [_radioId, "DefaultDisplay"] call FUNC(changeState);
    };
};
