#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if a unit has a specific item.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item to be checked <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "acre2_vhf30108"] call acre_sys_core_fnc_hasItem
 *
 * Public: No
 */

params [["_unit", objNull], ["_item", ""]];

if (!GVAR(aceLoaded)) then {
    _item in ([_unit] call FUNC(uniqueItems))
} else {
    _item in ([_unit] call ace_common_fnc_uniqueItems)
}
