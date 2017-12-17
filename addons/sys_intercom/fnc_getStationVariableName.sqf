/*
 * Author: ACRE2Team
 * Gets the variable name for accessing intercom configuration in the players position.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * Variable name, string of length 0 if not found <STRING>
 *
 * Example:
 * [vehicle acre_player, acre_player] call acre_sys_intercom_fnc_getStationVariableName
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

private _found = false;
private _varName = QGVAR(station_);
{
    if (_unit isEqualTo (_x select 0)) then {
        private _role = _x select 1;
        _varName = _varName + _role;
        if (_role in ["cargo", "turret"]) then {
            if (_role isEqualTo "cargo") then {
                _varName = _varName + format ["_%1", _x select 2];
            } else {
                _varName = _varName + format ["_%1", _x select 3];
            };
        };
        _found = true;
    };
    if (_found) exitWith {};
} forEach (fullCrew [_vehicle, "", false]);

if (!found) then {
    _varName = "";
};

_varName
