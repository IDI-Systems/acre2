#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Dummy function for creating actions on vehicles (open of hatches, lights, etc) once the infantry phone is picked up.
 *
 * Arguments:
 * 0: Vehicle with infantry phone <OBJECT>
 * 1: Infantry phone unit <OBJECT>
 * 2: Infantry phone action (1: return, 2: pick-up, 3: give, 4: switch network) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player, 1] call acre_sys_intercom_fnc_noApiFunction
 *
 * Public: No
 */

TRACE_1("This is the dummy function for infantry phone: %1",QFUNC(noApiFunction));
