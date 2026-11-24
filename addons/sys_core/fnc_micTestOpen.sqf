#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Opens the microphone test, on top of the given display (or the topmost one).
 *
 * Arguments:
 * 0: Parent display <DISPLAY> (default: topmost display)
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_micTestOpen
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [["_parent", displayNull]];
if (isNull _parent) then {
    _parent = allDisplays select (count allDisplays - 1);
};
_parent createDisplay QGVAR(MicTest);
