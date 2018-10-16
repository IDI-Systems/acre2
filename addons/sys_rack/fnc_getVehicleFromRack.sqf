#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the vehicle object for a given rack ID.
 *
 * Arguments:
 * 0: Rack ID <STRING>
 *
 * Return Value:
 * Vehicle <OBJECT>
 *
 * Example:
 * ["ACRE_VRC110_ID_1"] call acre_sys_rack_fnc_getVehicleFromRack
 *
 * Public: No
 */

params ["_rackId"];

private _return = GET_STATE_RACK(_rackId,"vehicle");
if (isNil "_return") then {
    _return = objNull;
};

_return
