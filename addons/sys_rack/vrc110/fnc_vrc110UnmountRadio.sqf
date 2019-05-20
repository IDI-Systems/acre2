#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Unmounts the given radio from an AN/VRC110 vehicle rack.
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
 * [cursorTarget] call acre_sys_rack_fnc_vrc110UnmountRadio
 *
 * Public: No
 */

params ["", "", "_eventData", ""];

private _radioId = _eventData;

// Switch back to battery mode.
[_radioId, "setState", ["powerSource", "BAT"]] call EFUNC(sys_data,dataEvent);

private _audioPath = [_radioId, "getState", "audioPath"] call EFUNC(sys_data,dataEvent);

if (_audioPath == "RACKSPEAKER") then {
    [_radioId, "setState", ["audioPath", "TOPAUDIO"]] call EFUNC(sys_data,dataEvent);
};
