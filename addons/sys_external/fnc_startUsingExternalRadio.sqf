/*
 * Author: ACRE2Team
 * Start using an external radio
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 * 1: Radio owner <OBJECT>
 * 2: End used <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", cursorTarget, acre_player] call acre_sys_external_startUsingExternalRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioID", "_owner", "_endUser"];

[_radioId, "setState", ["isUsedExternally", [true, _owner, _endUser]]] call EFUNC(sys_data,dataEvent);

// Add the radio to the player
ACRE_ACTIVE_EXTERNAL_RADIOS pushBackUnique _radioId;

player sideChat format ["Start using %1", _radioId];
