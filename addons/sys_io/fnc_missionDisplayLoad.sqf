#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Move VOIP channel on main display load.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_sys_io_fnc_missionDisplayLoad
 *
 * Public: No
 */

if (GVAR(serverStarted) && {isMultiplayer}) then {
    // Move VOIP channel on display 46 (main display) initialization
    call FUNC(voipChannelMove);
};
