#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns all radios defined in CfgAcreRadios. Caches result for future calls.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 1: Radio Class Names <ARRAY>
 * 2: Radio Display Names <ARRAY>
 *
 * Example:
 * [] call acre_api_fnc_getAllRadios;
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,getAllRadios)
