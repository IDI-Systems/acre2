/*
 * Author: ACRE2Team
 * Mount radio classname
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_vrc103MountRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId", "", "_eventData", ""];

private _radioId = _eventData;

// 26 Pin Connector
private _attributes = HASH_CREATE;
[_rackId, 3, _radioId, 2, _attributes, false] call EFUNC(sys_components,attachComplexComponent);

//Enable VAA Mode.
[_radioId, "setState", ["powerSource", "VAU"]] call EFUNC(sys_data,dataEvent);
