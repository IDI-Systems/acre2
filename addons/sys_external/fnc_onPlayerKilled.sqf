#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles death of unit, primarily for handling local player death. External radios are returned to the original owner.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [player] call acre_sys_external_fnc_onPlayerKilled
 *
 * Public: No
 */

params ["_unit"];

if (_unit == acre_player) then {
    // All external radios in use are now returned to the owner
    {
        private _owner = [_x] call FUNC(getExternalRadioOwner);
        [_x, _owner] call FUNC(stopUsingExternalRadio);
    } forEach ACRE_ACTIVE_EXTERNAL_RADIOS;
};

true
