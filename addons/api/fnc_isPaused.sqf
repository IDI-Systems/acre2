#include "script_component.hpp"
/*
 * Author: Thymo-
 * Check if ACRE is paused
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Paused <BOOL>
 *
 * Example:
 * [] call acre_api_fnc_isPaused
 *
 * Public: Yes
 */

 [] call EFUNC(sys_core,isPaused);
