#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks wether a rack can have its radios unmounted.
 *
 * Arguments:
 * 0: Unique rack ID <STRING>
 *
 * Return Value:
 * Racked radio can be unmounted <BOOL>
 *
 * Example:
 * ["ACRE_VRC103_ID_1"] call acre_api_fnc_isRackRadioRemovable
 *
 * Public: Yes
 */

params [
    ["_rackId", "", [""]]
];

[_rackId] call EFUNC(sys_rack,isRadioRemovable)
