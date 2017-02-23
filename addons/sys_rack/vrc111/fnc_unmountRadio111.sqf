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
 * [cursorTarget] call acre_sys_rack_fnc_unmountRadio110;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_rackId", "_event", "_eventData", "_radioData"];

private _radioId = _eventData;

// Switch back to battery mode.
[_radioId, "setState", ["powerSource", "BAT"]] call EFUNC(sys_data,dataEvent);
