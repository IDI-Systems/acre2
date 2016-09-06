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

GVAR(fpsCount) = 0;
GVAR(lastCount) = -1;
// prepare our handlers list
uiNamespace setVariable ["ACRE_PFHIDD", (_this select 0)];
// acre_player sideChat "LOL!!!!!!!!!!!";
((_this select 0) displayCtrl 50909) ctrlSetEventHandler ["Draw", QUOTE(if(!(isNull player)) then { [_this] call FUNC(perFrame_onFrame); };) ];
[] call FUNC(perFrame_TriggerClient);
// acre_player sideChat "FFFUFUFUFUFUF";
