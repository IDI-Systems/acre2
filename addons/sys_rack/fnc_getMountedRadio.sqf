#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the stashed radio in a vehicle. This may be an un-intialized radio or an initialized radio e.g. "ACRE_PRC152" or "ACRE_PRC152_ID_1"
 *
 * Arguments:
 * 0: Rack ID <STRING>
 *
 * Return Value:
 * Radio classname or ID, "" if nothing is stashed <STRING>
 *
 * Example:
 * ["ACRE_VRC110_ID_1"] call acre_sys_rack_fnc_getMountedRadio
 *
 * Public: No
 */
 
params [["_rackId",""]];

private _mountedRadio = GET_STATE_RACK(_rackId,"mountedRadio");

if (isNil "_mountedRadio") then { _mountedRadio = ""; };

_mountedRadio;
