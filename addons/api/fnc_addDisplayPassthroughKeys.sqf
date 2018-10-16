#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds key handling compatibility to a custom display, which otherwise does not pass through CBA keybinds.
 * Must be called after display has been loaded.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Successfully added passthrough key handling <BOOL>
 *
 * Example:
 * [display] call acre_api_fnc_addDisplayPassthroughKeys
 *
 * Public: Yes
 */

if (!hasInterface) exitWith {};

_this call EFUNC(sys_core,addDisplayPassthroughKeys);
