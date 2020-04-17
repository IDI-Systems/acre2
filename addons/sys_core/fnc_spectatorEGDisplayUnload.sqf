#include "script_component.hpp"
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

// Do not switch the player out of spectator if the "MenuPosition" respawn template is in use
if (!(missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]) AND !(missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false])) then {
	[] call FUNC(spectatorOff);
};