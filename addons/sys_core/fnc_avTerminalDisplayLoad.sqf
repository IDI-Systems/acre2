#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Enables keybinds in AV Terminal display.
 *
 * Arguments:
 * AV Terminal Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_avTerminalDisplayLoad
 *
 * Public: No
 */

params ["_display"];

diag_log "av terminal load";

// Key handling compatibility for AV Terminal (UAV Terminal)
[_display] call FUNC(addDisplayPassthroughKeys);
