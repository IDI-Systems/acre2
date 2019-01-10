#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Removes a radio from the unit's spectator radio list. Unit must be local.
 *
 * Arguments:
 * 0: Player unit <OBJECT> (default: objNull)
 * 1: Unique Radio or Rack ID <STRING> (default: "")
 *
 * Return Value:
 * Radio successfully removed <BOOL>
 *
 * Example:
 * [player, "acre_prc343_id_1"] call acre_api_fnc_removeSpectatorRadio
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]],
    ["_radioId", "", [""]]
];

if (isNull _unit || {!local _unit} || {!isPlayer _unit} || {!([_radioId] call EFUNC(sys_radio,radioExists))}) exitWith {

    if (!local _unit) then {
        ERROR_1("Unit %1 is not local. Aborting",_unit);
    };

    if (!isPlayer _unit) then {
        ERROR("Unit must be a player");
    };

    if !([_radioId] call EFUNC(sys_radio,radioExists)) then {
        ERROR_1("Radio %1 does not exist",_radioId);
    };

    false
};

// Get mounted radio if it is a rack
private _id = [_radioId] call EFUNC(sys_rack,getMountedRadio);
if !(_id isEqualTo "") then {
    _radioId = _id;
};

private _index = ACRE_SPECTATOR_RADIOS deleteAt (ACRE_SPECTATOR_RADIOS find _radioId);

!isNil "_index"
