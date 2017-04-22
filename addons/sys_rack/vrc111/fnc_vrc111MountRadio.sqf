/*
 * Author: ACRE2Team
 * Mount the given radio into an AN/VRC111 vehicle rack.
 *
 * Arguments:
 * 0: Unique rack ID <STRING>
 * 1: Event type <STRING> (Unused)
 * 2: Event data with unique radio ID <STRING>
 * 3: Radio data <ARRAY> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_vrc111MountRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId", "", "_eventData", ""];

private _radioId = _eventData;

// 32 Pin Connector
private _attributes = HASH_CREATE;
[_rackId, 4, _radioId, 2, _attributes, false] call EFUNC(sys_components,attachComplexComponent);

//Enable VAA Mode.
[_radioId, "setState", ["powerSource", "VAA"]] call EFUNC(sys_data,dataEvent);
