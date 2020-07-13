#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles selecting an entry in the spectator display's radio list.
 *
 * Arguments:
 * 0: List <CONTROL>
 * 1: Index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ctrlList, 0] call acre_sys_spectator_fnc_handleListSelect
 *
 * Public: No
 */

params ["_ctrlList", "_index"];

private _radioId = _ctrlList lbData _index;
private _radioIndex = ACRE_SPECTATOR_RADIOS find _radioId;

if (_radioIndex == -1) then {
    ACRE_SPECTATOR_RADIOS pushBack _radioId;
    _ctrlList lbSetPicture [_index, ICON_CHECKED];
} else {
    ACRE_SPECTATOR_RADIOS deleteAt _radioIndex;
    _ctrlList lbSetPicture [_index, ICON_UNCHECKED];
};
