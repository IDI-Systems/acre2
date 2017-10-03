/*
 * Author: ACRE2Team
 * Gets the connected intercoms.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_getWiredIntercom
 *
 * Public: No
 */
#include "script_component.hpp"

params [["_rackId",""]];

private _intercom = GET_STATE_RACK(_rackId,"wiredIntercoms");
private _wiredIntercoms = [];

{
    _wiredIntercoms pushBack (_x select 0);
} forEach _intercom;

_wiredIntercoms
