/*
 * Author: ACRE2Team
 * Start using an external radio
 *
 * Arguments:
 * 0: Unique radio identity <STRING>
 * 1: End used <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", acre_player] call acre_sys_external_startUsingExternalRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioID", "_endUser"];

[_radioId, "setState", ["isUsedExternally", [true, _endUser]]] call EFUNC(sys_data,dataEvent);

// Add the radio to the player
ACRE_ACTIVE_EXTERNAL_RADIOS pushBackUnique _radioId;

[format ["Start using %1", _radioId]] call EFUNC(sys_core,displayNotification);
