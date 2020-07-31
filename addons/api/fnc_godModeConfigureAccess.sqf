#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Configures the access to God Mode.
 *
 * Arguments:
 * 0: Access to the BI Chat Channel functionality <BOOL> (default: false)
 * 1: Access to Group presets functionality <BOOL> (default: false)
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [true, false] call acre_api_fnc_godModeConfigureAccess
 *
 * Public: Yes
 */

params [
    ["_accessChatChannel", false, [false]],
    ["_accessGroups", false, [false]]
];

EGVAR(sys_godmode,accessAllowed) = [_accessChatChannel, _accessGroups];

true
