/*
 * Author: ACRE2Team
 * Disables spectator mode on Vanilla Spectator (EG Spectator) display unload.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_spectatorEGDisplayUnload
 *
 * Public: No
 */
#include "script_component.hpp"

[] call FUNC(spectatorOff);
