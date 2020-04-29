#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Configures the intercom system of a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Intercom Configs <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_configIntercom
 *
 * Public: No
 */

params ["_vehicle", "_intercoms"];

private _type = typeOf _vehicle;

private _intercomNames = [];
private _intercomPositions = [];
private _intercomExceptions = [];
private _intercomLimitedPositions = [];
private _intercomMasterStation = [];
private _numLimitedPositions = [];
private _intercomConnectByDefault = [];
private _broadcasting = [];
private _accent = [];

{
    private _name = toLower (configName _x);
    private _displayName = getText (_x >> "displayName");
    private _shortName = getText (_x >> "shortName");
    private _allowedPositions = getArray (_x >> "allowedPositions");
    private _disabledPositions = getArray (_x >> "disabledPositions");
    private _limitedPositions = getArray (_x >> "limitedPositions");
    private _numLimPositions = getNumber (_x >> "numLimitedPositions");
    private _connectedByDefault = getNumber (_x >> "connectedByDefault");
    private _masterPositions = getArray (_x >> "masterPositions");
    private _availabeIntercomPositions = [];


    if (count _shortName > 5) then {
        WARNING_3("Intercom %1 short name %2 is longer than 5 characters for %3",_name,_shortName,_type);
    };

    // Check if the entry in allowed positions is correct
    if (_allowedPositions isEqualTo []) then {
        WARNING_2("Intercom %1 has no entry for allowed positions array for %2 - defaulting to crew",_name,_type);

        // Use Standard configuration
        // Driver, commander and gunner positions. Only select thoses that are defined.
        {
            private _role = _x;
            private _crew = fullCrew [_vehicle, _role, true];
            {
                if (_role == toLower (_x select 1)) then {
                    _availabeIntercomPositions pushBackUnique [_role];
                };
            } forEach _crew;
        } forEach ["driver", "commander", "gunner"];

        // Turrets excluding FFV turrets
        {
            _availabeIntercomPositions pushBackUnique (format ["turret_%1", _x]);
        } forEach allTurrets [_vehicle, false];
    } else {
        _availabeIntercomPositions = [_vehicle, _allowedPositions] call EFUNC(sys_core,processVehicleSystemAccessArray);
    };

    // Add limited positions. Positions in which non-intercom members can communicate temporarily
    private _limitedIntercomPositions = [_vehicle, _limitedPositions] call EFUNC(sys_core,processVehicleSystemAccessArray);
    if (!(_limitedIntercomPositions isEqualto []) && {_numLimPositions isEqualTo []}) then {
        //_limitedIntercomPositions = [];
        WARNING_2("Intercom %1 has limited positions defined but no actual limit of simultaneous connections for %2 - ignoring limited positions",_name,_type);
    };

    // Remove all exceptions
    private _temp = [_vehicle, _disabledPositions] call EFUNC(sys_core,processVehicleSystemAccessArray);
    private _exceptionsIntercomPositions = [];
    {
        if (_x in _availabeIntercomPositions) then {
            _availabeIntercomPositions deleteAt (_availabeIntercomPositions find _x);
        } else {
            // This could be an FFV turret
            _exceptionsIntercomPositions pushBackUnique _x;
        };
    } forEach _temp;

    // Master station
    private _masterStationPositions = [_vehicle, _masterPositions] call EFUNC(sys_core,processVehicleSystemAccessArray);
    {
        if !(_x in _availabeIntercomPositions) exitWith {
            WARNING_3("Intercom %1 has a master station entry (%2) that has no access to that intercom for %3 - ignoring master positions",_name,_x,_vehicle);
        };
    } forEach _masterStationPositions;

    // Check that limitied positions are not defined in available positions
    {
        if (_x in _availabeIntercomPositions) exitWith {
            _limitedIntercomPositions = [];
            WARNING_3("Intercom %1 has limited positions defined (%2) that overlap with allowed positions for %3 - ignoring limited positions",_name,_x,_vehicle);
        };
    } forEach _limitedIntercomPositions;

    _intercomNames pushBack [_name, _displayName, _shortName];
    _intercomPositions pushBack _availabeIntercomPositions;
    _intercomExceptions pushBack _exceptionsIntercomPositions;
    _intercomLimitedPositions pushBack _limitedIntercomPositions;
    _numLimitedPositions pushBack _numLimPositions;
    _intercomConnectByDefault pushBack _connectedByDefault;
    _intercomMasterStation pushBack _masterStationPositions;
    _broadcasting pushBack [false, objNull];
    _accent pushBack false;
} forEach _intercoms;

[_vehicle, _intercomPositions, _intercomExceptions, _intercomLimitedPositions, _intercomConnectByDefault, _intercomMasterStation] call FUNC(configIntercomStations);

if (didJIP) then {
    if ((_vehicle getVariable [QGVAR(intercomNames), []]) isEqualTo []) then {
        _vehicle setVariable [QGVAR(intercomNames), _intercomNames];
    };

    if ((_vehicle getVariable [QGVAR(numLimitedPositions), []]) isEqualTo []) then {
        _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions];
    };

    if ((_vehicle getVariable [QGVAR(broadcasting), []]) isEqualTo []) then {
        _vehicle setVariable [QGVAR(broadcasting), _broadcasting];
    };

    if ((_vehicle getVariable [QGVAR(accent), []]) isEqualTo []) then {
        _vehicle setVariable [QGVAR(accent), _accent];
    };
} else {
    _vehicle setVariable [QGVAR(intercomNames), _intercomNames];
    _vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions];
    _vehicle setVariable [QGVAR(broadcasting), _broadcasting];
    _vehicle setVariable [QGVAR(accent), _accent];
};
