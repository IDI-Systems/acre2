#include "script_component.hpp"
/*
 * Author: Brett Mayson
 * Checks if the local player is in the Zeus interface.
 *
 * Return Value:
 * In Zeus Interface <BOOL>
 *
 * Example:
 * _inZeus = call acre_sys_core_fnc_inZeus
 *
 * Public: No
 */

!isNull (findDisplay ZEUS_INTERFACE_DISPLAY)
