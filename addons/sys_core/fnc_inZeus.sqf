/*
 * Author: SynixeBrett
 * Returns true if the local player is in the Zeus interface
 *
 * Return Value:
 * In Zeus Interface <BOOL>
 *
 * Example:
 * _inZeus = call acre_sys_core_fnc_inZeus
 *
 * Public: No
 */

#define ZEUS_INTERFACE_DISPLAY 312

!isNull (findDisplay ZEUS_INTERFACE_DISPLAY)
