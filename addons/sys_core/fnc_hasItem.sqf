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
#include "script_component.hpp"

params [["_unit", objNull], ["_item", ""]];

_item in (items _unit)
