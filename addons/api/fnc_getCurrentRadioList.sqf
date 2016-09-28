/*
 * Author: ACRE2Team
 * Retrieves the array of current unique radio IDs that are on the local player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Array of radio IDs which are strings <ARRAY>
 *
 * Example:
 * [] call acre_api_fnc_getCurrentRadioList;
 *
 * Public: Yes
 */
#include "script_component.hpp"

private _ret = [] call EFUNC(sys_data,getPlayerRadioList);

_ret
