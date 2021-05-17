#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Check if a remote TS Client Should be muted
 *
 * Arguments:
 * 0: Unit
 * 1: Remote TS Id
 * 2: Dynamic Position
 *
 * Return Value:
 * Unit Should Be Muted
 *
 * Example:
 * [] call acre_sys_core_fnc_shouldBeMuted
 *
 * Public: No
 */
params ["_remoteUser", "_remoteTs3Id", "_dynamicPos"];

if (_remoteUser in EGVAR(sys_godmode,speakingGods)) exitWith { false };
if (ACRE_IS_SPECTATOR && {_remoteTs3Id in ACRE_SPECTATORS_LIST}) exitWith { false };
if (!ACRE_IS_SPECTATOR && {_remoteTs3Id in ACRE_SPECTATORS_LIST}) exitWith { true };
if !([_remoteUser] call FUNC(getAlive)) exitWith { false };

GVAR(enableDistanceMuting)
&& {_remoteUser distance _dynamicPos > 300}
&& {!(_remoteUser in GVAR(speakers))}
