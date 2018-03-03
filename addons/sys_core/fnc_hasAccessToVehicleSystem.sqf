/*
 * Author: ACRE2Team
 * Checks if the given unit can have access to a vehicle system like intercom or vehicle racks.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Allowed positions <ARRAY>
 * 3: Forbidden positions <ARRAY>
 * 4: Maximum distance for external use <NUMBER> (default: 0)
 *
 * Return Value:
 * True if the system is available, false otherwise <BOOL>
 *
 * Example:
 * [cursorTarget, player, ["driver", "commander"], ["gunner"]] call acre_sys_core_fnc_hasAccessToVehicleSystem
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_allowedPositions", "_forbiddenPositions", ["_maxDistance", 0]];

private _systemAvailable = false;

if (!alive _vehicle) exitWith {_systemAvailable};

// Check external systems
if ((vehicle _unit == _unit) && {"external" in _allowedPositions}) exitWith {
    if (_vehicle distance _unit <= _maxDistance) then {
        _systemAvailable = true
    };
    _systemAvailable
};

private _fullCrew = fullCrew [_vehicle, "", true];

private "_role";
{
    if (_unit isEqualTo (_x select 0)) then {
        _role = toLower (_x select 1);
        if (_role in ["cargo", "turret"]) then {
            if (_role isEqualTo "cargo") then {
                _role = format ["%1_%2", _role, _x select 2];
            } else {
                _role = format ["%1_%2", _role, _x select 3];
            };
        };

        if (isTurnedOut _unit) then {
            _role = format ["turnedout_%1", _role];
        };
    };
} forEach _fullCrew;

if (_role in _allowedPositions && {!(_role in _forbiddenPositions)}) then {
    _systemAvailable = true;
};

_systemAvailable
