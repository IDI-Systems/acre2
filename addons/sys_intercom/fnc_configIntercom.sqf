/*
 * Author: ACRE2Team
 * Configures the intercom system of a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_configIntercom
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _classname = typeOf _vehicle;
private _intercoms = configFile >> "CfgVehicles" >> _classname >> "AcreIntercoms";
private _intercomNames = [];
private _intercomDisplayNames = [];
private _intercomPositions = [];
private _intercomExceptions = [];
private _intercomLimitedPositions = [];
private _numLimitedPositions = [];
private _intercomConnectByDefault = [];
private _unitsIntercom = [];

{
    private _name = toLower (configName _x);
    private _displayName = getText (_x >> "displayName");
    private _allowedPositions = getArray (_x >> "allowedPositions");
    private _disabledPositions = getArray (_x >> "disabledPositions");
    private _limitedPositions = getArray (_x >> "limitedPositions");
    private _numLimPositions = getNumber (_x >> "numLimitedPositions");
    private _connectedByDefault = getNumber (_x >> "connectedByDefault");
    private _availabeIntercomPositions = [];

    // Check if the entry in allowed positions is correct
    if (_allowedPositions isEqualTo []) then {
        WARNING_2("Vehicle type %1 has no entry for allowed positions array. This is not supported. Defaulting to crew for intercom network %2.",_type,_name);

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
            _availabeIntercomPositions pushBackUnique ["turret", _x];
        } forEach allTurrets [_vehicle, false];
    } else {
        _availabeIntercomPositions = [_vehicle, _allowedPositions] call EFUNC(sys_core,processVehicleSystemAccessArray);
    };

    // Add limited positions. Positions in which non-intercom members can communicate temporarily
    private _limitedIntercomPositions = [_vehicle, _limitedPositions] call EFUNC(sys_core,processVehicleSystemAccessArray);
    if (!(_limitedIntercomPositions isEqualto []) && {_numLimPositions isEqualTo []}) then {
        //_limitedIntercomPositions = [];
        WARNING_2("Vehicle type %1 has limited positions defined but no actual limit of simultaneous connections. Ignoring limited positions for intercom network %2",_vehicle, _name);
    };

    // Remove all exceptions
    private _temp = [_vehicle, _disabledPositions] call EFUNC(sys_core,processVehicleSystemAccessArray);
    private _exceptionsIntercomPositions = [];
    {
        if (_x in _availabeIntercomPositions) then {
            _availabeIntercomPositions = _availabeIntercomPositions - [_x];
        } else {
            // This could be an FFV turret
            _exceptionsIntercomPositions pushBackUnique _x;
        };
    } forEach _temp;

    // Check that limitied positions are not defined in available positions
    {
        if (_x in _availabeIntercomPositions) exitWith {
            _limitedIntercomPositions = [];
            WARNING_2("Vehicle type %1 has limited positions defined that overlap with allowed positions. Ignoring limited positions for intercom network %2",_vehicle,_name);
        };
    } forEach _limitedIntercomPositions;

    _intercomNames pushBack _name;
    _intercomDisplayNames pushBack _displayName;
    _intercomPositions pushBack _availabeIntercomPositions;
    _intercomExceptions pushBack _exceptionsIntercomPositions;
    _intercomLimitedPositions pushBack _limitedIntercomPositions;
    _numLimitedPositions pushBack _numLimPositions;
    _intercomConnectByDefault pushBack _connectedByDefault;
    _unitsIntercom pushBack [];
} forEach (configProperties [_intercoms, "isClass _x", true]);

_vehicle setVariable [QGVAR(intercomNames), _intercomNames];
_vehicle setVariable [QGVAR(intercomDisplayNames), _intercomDisplayNames];
_vehicle setVariable [QGVAR(allowedPositions), _intercomPositions];
_vehicle setVariable [QGVAR(forbiddenPositions), _intercomExceptions];
_vehicle setVariable [QGVAR(limitedPositions), _intercomLimitedPositions];
_vehicle setVariable [QGVAR(numLimitedPositions), _numLimitedPositions];
_vehicle setVariable [QGVAR(connectByDefault), _intercomConnectByDefault];
_vehicle setVariable [QGVAR(unitsIntercom), _unitsIntercom];
