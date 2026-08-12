#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Allows for further processing of signal data.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "handleSignalData" <STRING> (Unused)
 * 2: Event data <ARRAY>
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Array returning the modified signal data <ARRAY>
 *
 * Example:
 * ["ACRE_WS38_ID_1", "handleSignalData", _eventData, [], false] call acre_sys_ws38_fnc_handleSignalData
 *
 * Public: No
 */

params ["", "", "_eventData", ""];

_eventData;
