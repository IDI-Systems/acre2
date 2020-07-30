#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sends a text message to the specified God Mode group.
 *
 * Arguments:
 * 0: Text <STRING> (default: "")
 * 1: Group ID (0-based index) <NUMBER> (default: 0)
 *
 * Return Value:
 * Text message sent successfully <BOOL>
 *
 * Example:
 * ["sample text", 2] call acre_api_fnc_godModeSendText
 *
 * Public: Yes
 */

params [
    ["_text", "", [""]],
    ["_group", 0, [0]]
];

if (_text isEqualTo "") exitWith {
    ERROR("Empty text.");
    false
};

if ((_group < 0) || (_group >= GODMODE_NUMBER_OF_GROUPS)) exitWith {
    ERROR_1("Invalid group ID. Group ID must be between 0 and %1, but %2 is entered.",GODMODE_NUMBER_OF_GROUPS-1,_group);
    false
};

[_text, _group] call EFUNC(sys_godmode,sendText);

true
