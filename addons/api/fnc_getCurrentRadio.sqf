/*
 * Author: ACRE2Team
 * Returns the unique radio ID of the currently active radio for the local player object.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Radio ID <STRING>
 *
 * Example:
 * [] call acre_api_fnc_getCurrentRadio;
 *
 * Public: Yes
 */
#include "script_component.hpp"

if(isNil "ACRE_ACTIVE_RADIO") exitWith { "" };
ACRE_ACTIVE_RADIO
