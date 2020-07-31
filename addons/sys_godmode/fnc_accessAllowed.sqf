#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Check if the player has access to God Mode.
 *
 * Arguments:
 * 0: Action <NUMBER>
 *
 * Return Value:
 * True if the player has access to God Mode, false otherwise
 *
 * Example:
 * [0] call acre_sys_godMode_fnc_accessAllowed
 *
 * Public: No
 */

params ["_action"];

// Administrators and curators can access God Mode
if (IS_ADMIN || {[] call EFUNC(sys_core,inZeus)}) exitWith { true };

private _allowed = false;
if (_action == GODMODE_CURRENTCHANNEL) then {
    _allowed = GVAR(accessAllowed) select GODMODE_ACCESS_ALLOWED_CHANNEL;
} else {
    _allowed = GVAR(accessAllowed) select GODMODE_ACCESS_ALLOWED_GROUP;
};

_allowed
