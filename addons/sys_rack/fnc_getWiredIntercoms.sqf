#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the connected intercoms.
 *
 * Arguments:
 * 0: Unique rack ID <STRING>
 *
 * Return Value:
 * Array of intercom unique names
 *
 * Example:
 * ["acre_vrc103_id_1"] call acre_sys_rack_fnc_getWiredIntercoms
 *
 * Public: No
 */

params [["_rackId",""]];

private _intercoms = GET_STATE_RACK(_rackId,"wiredIntercoms");

if (isNil "_intercoms") exitWith {[]};

_intercoms
