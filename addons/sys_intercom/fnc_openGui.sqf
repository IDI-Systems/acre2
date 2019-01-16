#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Opens the intercom gui.
 *
 * Arguments:
 * 0: Intercom network <NUMBER>
 * 1: Open master statio <BOOL>
 *
 * Return Value:
 * GUI successfully opened <BOOL>
 *
 * Example:
 * [1, true] call acre_sysIntercom_fnc_openGui
 *
 * Public: No
 */

params ["_intercomNetwork", ["_openMasterStation", false]];

if (vehicle acre_player isEqualTo acre_player) exitWith {};

// Get the intercom type
disableSerialization;

if (!_openMasterStation) then {
    createDialog "VIC3FFCS_IntercomDialog";
};

true
