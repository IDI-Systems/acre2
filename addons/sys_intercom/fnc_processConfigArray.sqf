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
            // Driver, commander and gunner positions
            {
                _processedArray pushBackUnique _x
            } forEach [["driver"], ["commander"], ["gunner"]];

            // Turrets excluding FFV turrets
            {
                _processedArray pushBackUnique ["turret", _x];
            } forEach allTurrets [_vehicle, false];
        } else {
            // Position is of type commander, driver or gunners
            _processedArray pushBackUnique [_x];
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
                    _positionType = "turret";
                    {
                        _processedArray pushBackUnique [_positionType, _x];
                    } forEach _turretPositions;
                };
            };
        } else {
            if (_positionType == "ffv") then {_positionType = "turret";};
            for [{private _i = 1}, {_i < count (_x select 1)}, {_i = _i + 1}] do {
                _processedArray pushBackUnique [_positionType, _x select _i];
            };
        };
    };
} forEach _configArray;

_processedArray
