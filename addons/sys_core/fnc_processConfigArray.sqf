/*
 * Author: ACRE2Team
 * Parses the intercom configuration arrays and converts it to a usable format.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Configuration array <ARRAY>
 *
 * Return Value:
 * Formatted array <ARRAY>
 *
 * Example:
 * [cursorTarget, ["driver", ["cargo", 1, 2]]] call acre_sys_intercom_processConfigArray
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_configArray"];

private _processedArray = [];

{
    if (typeName _x == "STRING") then {
        if (_x == "crew") then {
            // Add Standard configuration
            // Driver, commander and gunner positions. Only select thoses that are defined.
            {
                private _role = _x;
                private _crew = fullCrew [_vehicle, _role, true];
                {
                    if (_role == toLower (_x select 1)) then {
                        _processedArray pushBackUnique [_x];
                    };
                } forEach _crew;
            } forEach ["driver", "commander", "gunner"];

            // Turrets excluding FFV turrets
            {
                _processedArray pushBackUnique ["turret", _x];
            } forEach allTurrets [_vehicle, false];
        } else {
            if (_x == "copilot") then {
                private _copilot = (allTurrets [_vehicle, false]) select {getNumber ([_vehicle, _x] call CBA_fnc_getTurret >> "isCopilot") == 1};
                _processedArray pushBackUnique ["turret", _copilot];
            } else {
                // Position is of type commander, driver or gunners
                _processedArray pushBackUnique [_x];
            };
        };
    } else {
        // Position is of type cargo, turret or ffv.
        private _positionType = toLower (_x select 0);
        if (typeName (_x select 1) == "STRING" && {(_x select 1 == "all")}) then {
            switch (_positionType) do {
                case "cargo": {
                    private _cargoPositions = fullCrew [_vehicle, _positionType, true];
                    {
                        _processedArray pushBackUnique [_positionType, _x select 2];
                    } forEach _cargoPositions;
                };
                case "turret": {
                    private _turretPositions = allTurrets [_vehicle, false];
                    {
                        _processedArray pushBackUnique [_positionType, _x];
                    } forEach _turretPositions;
                };
                case "ffv": {
                    private _turretPositions = allTurrets [_vehicle, true] - allTurrets [_vehicle, false];
                    {
                        _processedArray pushBackUnique ["turret", _x];
                    } forEach _turretPositions;
                };
                case "turnedOut": {
                    _processedArray pushBackUnique ["turnedout", "all"];
                };
            };
        } else {
            if (_positionType == "ffv") then {_positionType = "turret";};
            for [{private _i = 1}, {_i < count _x}, {_i = _i + 1}] do {
                _processedArray pushBackUnique [_positionType, _x select _i];
            };
        };
    };
} forEach _configArray;

_processedArray
