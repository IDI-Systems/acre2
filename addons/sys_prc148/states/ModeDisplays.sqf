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

DFUNC(ModeDisplay_Render) = {
    params["_display"];

    GVAR(currentMenu) = [
        [
            ["audioPath", GET_STATE(audioPath), BIG_LINE_1, [1, 12], MENU_TYPE_LIST, FUNC(updateMode), ["INT AUDIO", "TOP AUDIO", "TOP SIDETON", "SIDE AUDIO", "SIDE SIDETON"], ["INTAUDIO", "TOPAUDIO", "TOPSIDETON", "SIDEAUDIO", "SIDESIDETON"]],
            ["beaconMode", "BEACON OFF", BIG_LINE_2, [1, 12], MENU_TYPE_MENU, {}],
            ["voiceMode", "VOICE MODE", BIG_LINE_3, [1, 12], MENU_TYPE_MENU, {}],
            ["cloningMode", "CLONING OFF", BIG_LINE_4, [1, 12], MENU_TYPE_MENU, {}]
        ]
    ];
    [_display, GVAR(currentMenu)] call FUNC(showMenu);
};

DFUNC(ModeDisplay_ESC) = {
    [GVAR(currentRadioId), "DefaultDisplay"] call FUNC(changeState);
};
