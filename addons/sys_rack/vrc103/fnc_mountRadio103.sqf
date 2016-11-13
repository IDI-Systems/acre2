/*
 * Author: ACRE2Team
 * Mount radio classname
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 *
 * Return Value:
 * RETURN VALUE <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_mountRadio103;
 *
 * Public: No
 */
#include "script_component.hpp"

params["_rackId", "_event", "_eventData", "_radioData"];

private _radioId = _eventData;

// 26 Pin Connector
[_rackId,3,_radioId,2,[],false] call EFUNC(sys_components,attachComplexComponent); 

//Enable VAA Mode.
[_radioId, "setState", ["powerSource", "VAU"]] call acre_sys_data_fnc_dataEvent;