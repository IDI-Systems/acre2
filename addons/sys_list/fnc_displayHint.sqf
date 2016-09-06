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
#include "script_component.hpp"
GVAR(hintTitle) = _this select 0;
GVAR(hintLine1) = _this select 1;
GVAR(hintLine2) = _this select 2;
GVAR(hintDuration) = 1;
if((count _this) == 4) then {
    GVAR(hintDuration) = _this select 3;
};

99911 cutRsc [QUOTE(GVAR(radioCycleDisplay)), "PLAIN", GVAR(hintDuration)];
99910 cutRsc [QUOTE(GVAR(radioCycleDisplayBG)), "PLAIN", 0.15];
