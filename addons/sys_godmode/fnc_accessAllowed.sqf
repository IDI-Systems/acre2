#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Check if the specified player or UID has access to God Mode.
 *
 * Arguments:
 * 0: Player or Player UID <OBJECT, NUMBER>
 *
 * Return Value:
 * True if the player/uid has access to God Mode, false otherwise
 *
 * Example:
 * [player] call acre_sys_godMode_fnc_accessAllowed
 *
 * Public: No
 */

params ["_uid"];

// Administrators and curators can access God Mode
if (((admin clientOwner) > 0) || {!isNull (getAssignedCuratorLogic acre_player)}) exitWith { true };

// Check additional UIDs
if (_uid isEqualType objNull) then {
    _uid = getPlayerUID _uid;
};

private _allowedUIDS = missionNamespace getVariable [QGVAR(allowedUIDS), []];

(_allowedUIDS find _uid) == -1
