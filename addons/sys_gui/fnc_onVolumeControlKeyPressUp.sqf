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

if (!(alive acre_player)) exitWith { false };

inGameUISetEventHandler ['PrevAction', 'false'];
inGameUISetEventHandler ['NextAction', 'false'];

disableSerialization;
GVAR(KeyBlock) = false;
57701 cutRsc [QUOTE(GVAR(VolumeControlDialog_Close)), "PLAIN"];
call FUNC(closeVolumeControl);


false
