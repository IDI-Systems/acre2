#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Displays a notification, using ACE3 notification if available, otherwise a silent hint.
 *
 * Arguments:
 * ACE3 Function arguments <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["text"] call acre_sys_core_fnc_displayNotification
 *
 * Public: No
 */

params ["_text", ["_iconOrSize", -1]]; // -1 if not supplied, must set default value for isEqualType

if (isClass (configFile >> "CfgPatches" >> "ace_common")) then {
    // If second argument is string, use picture, otherwise text
    if (_iconOrSize isEqualType "") then {
        _this call ace_common_fnc_displayTextPicture;
    } else {
        _this call ace_common_fnc_displayTextStructured;
    };
} else {
    // Just show text
    hintSilent _text;
};
