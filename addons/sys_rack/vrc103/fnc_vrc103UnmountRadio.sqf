/*
 * Author: ACRE2Team
 * Unmounts the given radio from an AN/VRC103 vehicle rack.
 *
 * Arguments:
 * 0: Unique rack ID <STRING> <Unused>
 * 1: Event type <STRING> (Unused)
 * 2: Event data with unique radio ID <STRING>
 * 3: Radio data <ARRAY> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_vrc103UnmountRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["", "", "_eventData", ""];

private _radioId = _eventData;

//Enable VAA Mode.
[_radioId, "setState", ["powerSource", "BAT"]] call EFUNC(sys_data,dataEvent);
