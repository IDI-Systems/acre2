/*
 * Author: ACRE2Team
 * Gets the current global output volume for all ACRE voices and radios.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * The current ACRE global volume (between 0 and 1) <NUMBER>
 *
 * Example:
 * [] call acre_api_fnc_getGlobalVolume;
 *
 * Public: Yes
 */
#include "script_component.hpp"

if(isNil "acre_sys_core_globalVolume") then {
    nil
};

acre_sys_core_globalVolume
