#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Disconnects the ground spike antenna and re-connects the default radio antenna.
 *
 * Arguments:
 * 0: Player or unit <OBJECT>
 * 1: Ground Spike Antenna <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player, cursorTarget] call acre_sys_gsa_fnc_disconnect
 *
 * Public: No
 */

params ["_unit", "_gsa"];

// Fire the event
[QGVAR(disconnectGsa), [_gsa, _unit]] call CBA_fnc_serverEvent;
[false] call EFUNC(sys_core,handleConnectorRope);
