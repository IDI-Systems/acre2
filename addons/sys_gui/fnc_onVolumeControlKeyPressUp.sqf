#include "script_component.hpp"
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

if (!GVAR(keyBlock)) exitWith {false};

inGameUISetEventHandler ["PrevAction", "false"];
inGameUISetEventHandler ["NextAction", "false"];

GVAR(keyBlock) = false;
disableSerialization;

(QGVAR(VolumeControlDialog) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
call FUNC(closeVolumeControl);

false
