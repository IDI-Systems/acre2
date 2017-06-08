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
    if (_x isEqualType "") then {
        switch (toLower _x) do {
            case "crew": {
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
            };
            case "copilot": {
                private _copilot = (allTurrets [_vehicle, false]) select {getNumber ([_vehicle, _x] call CBA_fnc_getTurret >> "isCopilot") == 1};
                {
                    _processedArray pushBackUnique ["turret", _x];
                } forEach _copilot;
            };
            default {
                // Position is of type commander, driver, gunner, inside or external
                _processedArray pushBackUnique [_x];
            };
        };
    } else {
        // Position is of type cargo, turret or ffv.
        private _positionType = toLower (_x select 0);
        if ((_x select 1) isEqualType "" && {_x select 1 == "all"}) then {
            switch (_positionType) do {
                case "cargo": {
                    {
                        _processedArray pushBackUnique [_positionType, _x select 2];
                    } forEach fullCrew [_vehicle, _positionType, true];
                };
                case "turret": {
                    {
                        _processedArray pushBackUnique [_positionType, _x];
                    } forEach allTurrets [_vehicle, false];
                };
                case "ffv": {
                    {
                        _processedArray pushBackUnique ["turret", _x];
                    } forEach (allTurrets [_vehicle, true] - allTurrets [_vehicle, false]);
                };
                case "turnedOut": {
                    _processedArray pushBackUnique ["turnedout", "all"];
                };
            };
        } else {
            if (_positionType == "ffv") then {_positionType = "turret";};
            for "_i" from 1 to (count _x - 1) do {
                _processedArray pushBackUnique [_positionType, _x select _i];
            };
        };
    };
} forEach _configArray;

_processedArray
