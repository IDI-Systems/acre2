#include "script_component.hpp"
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

params ["_vehicle", "_unit"];

private _found = false;
private _varName = "";
{
    if (_unit isEqualTo (_x select 0)) exitWith {
        private _role = toLower (_x select 1);
        _varName = format [QGVAR(station_%1), _role];
        if (_role in ["cargo", "turret"]) then {
            if (_role isEqualTo "cargo") then {
                _varName = format ["%1_%2", _varName, _x select 2];
            } else {
                _varName = format ["%1_%2", _varName, _x select 3];
            };
        };
        _found = true;
    };
} forEach (fullCrew [_vehicle, "", false]);

if (!_found) then {
    _varName = "";
};

_varName
