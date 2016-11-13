/*
 * Author: ACRE2Team
 * Returns the vehicle object for a given rack ID.
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * ["ACRE_VRC110_ID_1"] call acre_sys_rack_fnc_getVehicleFromRack;
 *
 * Public: No
 */
#include "script_component.hpp"

params["_rackId"];

private _return = GET_STATE_RACK(_rackId,"vehicle");
if (isNil "_return") then { _return = objNull; };

_return;