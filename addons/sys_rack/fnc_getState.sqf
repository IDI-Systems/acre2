#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Function for retrieving data from the data interface events
 *
 * Arguments:
 * 0: Rack ID <STRING>
 * 1: Event <STRING>
 * 2: Event Data <ANY>
 * 3: Rack Data <HASH>
 *
 * Return Value:
 * Any
 *
 * Example:
 * ["ACRE_VRC110_ID_1","getState","mountedRadio",(acre_sys_data_radioData getVariable "ACRE_VRC110_ID_1")] call acre_sys_rack_fnc_getState
 *
 * Public: No
 */

params ["", "", "_eventData", "_rackData"];

HASH_GET(_rackData,_eventData);
