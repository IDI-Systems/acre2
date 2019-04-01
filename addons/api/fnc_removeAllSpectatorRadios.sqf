#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Removes all spectator radios. Unit must be local.
 *
 * Arguments:
 * 0: Player unit <OBJECT> (default: objNull)
 *
 * Return Value:
 * Radios successfully removed <BOOL>
 *
 * Example:
 * [player] call acre_api_fnc_removeAllSpectatorRadios
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit || {!local _unit} || {!isPlayer _unit}) exitWith {

    if (!local _unit) then {
        ERROR_1("Unit %1 is not local. Aborting",_unit);
    };

    if (!isPlayer _unit) then {
        ERROR("Unit must be a player");
    };

    false
};

ACRE_SPECTATOR_RADIOS = [];

true
