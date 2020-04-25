#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Parses the intercom and racks configuration arrays and converts it to a usable format.
 *
 * The configuration arrays are used in order to determine seat functionality in a vehicle using high level entries like
 * "all", "inside", "crew". This function converts these configuration arrays to a format that is more easy to parse in
 * code.
 *
 * The following keywords are supported:
 * - crew: selects positions of driver, commander, gunner and all non-ffv turrets.
 * - copilot: selects the copilot seat
 * - all: can be used in combination with cargo, turret, ffv and turnedOut entries. Selects all entries that matches the
 *   vehicle role.
 * - cargo: identifier for cargo positions. It must be followed by a valid cargo index or the "all" keyword.
 * - turret: identifier for turret positions. It must be followed by a valid turret path or the "all" keyword.
 * - ffv: identifier for turret positions of the type ffv. It must be followed by a valid turret path or the "all" keyword.
 * - turnedOut: identifier for situations where the player is turned out of the vehicle. It must be followed by a valid
 *   turret path or the "all" keyword.
 * - inside: selects all seats inside the vehicle.
 *
 * The following cases are ilustrative examples of the outcome of this function:
 * - Configuration array ["driver", ["cargo", 1, 2]] -> ["driver", "cargo_1", "cargo_2"]
 * - Configuration array ["crew"] -> ["driver", "commander", "gunner", "turret_[0]", "turret_[1]"]
 * - Configuration array ["inside"] -> ["driver", "commander", "gunner", "cargo_1", "cargo_2", ..., "cargo_n"]
 * - Configuration array ["cargo", "all"] -> [["cargo_1"], ["cargo_2"], "cargo_3", ..., "cargo_n"]
 * - Configuration array [["turret", [1], [2]], [[turnedout, [3]]] -> ["turret_[1]", "turret_[2]", "turnedout_turret_[3]"]
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Configuration array <ARRAY>
 *
 * Return Value:
 * Formatted array <ARRAY>
 *
 * Example:
 * [cursorTarget, ["driver", ["cargo", 1, 2]]] call acre_sys_core_fnc_processVehicleSystemAccessArray
 *
 * Public: No
 */

params ["_vehicle", "_configArray"];

private _processedArray = [];

{
    if (_x isEqualType "") then {
        switch (toLower _x) do {
            case "crew": {
                // Add Standard configuration
                // Driver, commander and gunner positions. Only select thoses that are defined
                {
                    private _role = _x;
                    private _crew = fullCrew [_vehicle, _role, true];
                    {
                        if (_role == toLower (_x select 1)) then {
                            _processedArray pushBackUnique _role;
                        };
                    } forEach _crew;
                } forEach ["driver", "commander", "gunner"];

                // Turrets excluding FFV turrets
                {
                    _processedArray pushBackUnique (format ["turret_%1", _x]);
                } forEach allTurrets [_vehicle, false];
            };
            case "copilot": {
                private _copilot = (allTurrets [_vehicle, false]) select {getNumber ([_vehicle, _x] call CBA_fnc_getTurret >> "isCopilot") == 1};
                {
                    _processedArray pushBackUnique (format ["turret_%1", _x]);
                } forEach _copilot;
            };
            case "inside": {
                private _fullCrew = fullCrew [_vehicle, "", true];
                {
                    private _role = toLower (_x select 1);
                    if (_role in ["cargo", "turret"]) then {
                        if (_role isEqualTo "cargo") then {
                            _processedArray pushBackUnique (format ["%1_%2", _role, _x select 2]);
                        } else {
                            _processedArray pushBackUnique (format ["%1_%2", _role, _x select 3]);
                        };
                    } else {
                        _processedArray pushBackUnique _role;
                    };
                } forEach _fullCrew;
            };
            default {
                // Position is of type commander, driver, gunner or external
                _processedArray pushBackUnique _x;
            };
        };
    } else {
        // Position is of type cargo, turret or ffv.
        private _positionType = toLower (_x select 0);
        if ((_x select 1) isEqualType "" && {_x select 1 == "all"}) then {
            switch (_positionType) do {
                case "cargo": {
                    {
                        _processedArray pushBackUnique (format ["%1_%2", _positionType, _x select 2]);
                    } forEach fullCrew [_vehicle, _positionType, true];
                };
                case "turret": {
                    {
                        _processedArray pushBackUnique (format ["%1_%2", _positionType, _x]);
                    } forEach allTurrets [_vehicle, false];
                };
                case "ffv": {
                    {
                        _processedArray pushBackUnique (format ["turret_%1", _x]);
                    } forEach (allTurrets [_vehicle, true] - allTurrets [_vehicle, false]);
                };
                case "turnedout": {
                    _processedArray pushBackUnique "turnedout_all";
                };
            };
        } else {
            if (_positionType == "ffv") then {_positionType = "turret";};
            for "_i" from 1 to (count _x - 1) do {
                if (_positionType isEqualTo "turnedout") then {
                    if ((_x select _i) isEqualType []) then {
                        _processedArray pushBackUnique (format ["%1_turret_%2", _positionType, _x select _i]);
                    };

                    if ((_x select _i) isEqualType 0) then {
                        _processedArray pushBackUnique (format ["%1_cargo_%2", _positionType, _x select _i]);
                    };
                } else {
                    _processedArray pushBackUnique (format ["%1_%2", _positionType, _x select _i]);
                };
            };
        };
    };
} forEach _configArray;

_processedArray
