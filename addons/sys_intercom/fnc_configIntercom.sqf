/*
 * Author: ACRE2Team
 * Adds actions for using vehicle intercom externally and passenger intercom.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_intercomActions
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
private _intercomRestrictions = [];
private _intercomNumRestricted = [];
private _intercomConnectByDefault = [];
private _unitsIntercom = [];

systemChat format ["Config intercom"];

for "_i" from 0 to ((count _intercoms) - 1) do {
    private _x = _intercoms select _i;
    private _name = toLower (getText (_x >> "name"));
    private _displayName = getText (_x >> "displayName");
    private _allowedPositions = getArray (_x >> "allowedPositions");
    private _restrictedPositions = getArray ( _x >> "restrictedPositions");
    private _disabledPositions = getArray (_x >> "disabledPositions");
    private _intercomConnections = getNumber (_x >> "connections");
    private _connectedByDefault = getNumber (_x >> "connectedByDefault");

    // Check if the entry in allowed positions is the default one
    private _default = false;
    if (count _allowedPositions == 0 || "default" in _allowedPositions) then {
        _default = true;
        if (count _allowedPositions > 1) then {
            WARNING_1("Vehicle type %1 has the default entry followed by other options. This is not supported. Ignoring custom configuration for crew intercom.",_type);
            _default = true;
        };
    };

    private _availabeIntercomPositions = [];

    if (_default) then {
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
        _availabeIntercomPositions = [_vehicle, _allowedPositions] call EFUNC(sys_core,processConfigArray);
    };

    private _restrictedIntercomPositions = [];
    private _numRestrictedPositions = 0;

    if (count _restrictedPositions > 0) then {
        restrictedIntercomPositions = [_vehicle, _restrictedPositions select 0] call EFUNC(sys_core,processConfigArray);
        numRestrictedPositions = _restrictedPositions select 1;
    };

    // Remove all exceptions
    private _temp = [_vehicle, _disabledPositions] call EFUNC(sys_core,processConfigArray);
    private _exceptionsIntercomPositions = [];
    {
        if (_x in _availabeIntercomPositions || _x in _restrictedIntercomPositions) then {
            if (_x in _availabeIntercomPositions) then {
                _availabeIntercomPositions = _availabeIntercomPositions - [_x];
            } else {
                _restrictedIntercomPositions = _restrictedIntercomPositions - [_x];
            }
        } else {
            // This could be a FFV turret
            _exceptionsIntercomPositions pushBackUnique _x;
        };
    } forEach _temp;

    _intercomNames pushBack _name;
    _intercomDisplayNames pushBack _displayName;
    _intercomPositions pushBack _availabeIntercomPositions;
    _intercomExceptions pushBack _exceptionsIntercomPositions;
    _intercomRestrictions pushBack _restrictedIntercomPositions;
    _intercomNumRestricted pushBack _numRestrictedPositions;
    _intercomConnectByDefault pushBack _connectedByDefault;
    _unitsIntercom pushBack [];
};

_vehicle setVariable [QGVAR(intercomNames), _intercomNames];
_vehicle setVariable [QGVAR(intercomDisplayNames), _intercomDisplayNames];
_vehicle setVariable [QGVAR(allowedPositions), _intercomPositions];
_vehicle setVariable [QGVAR(forbiddenPositions), _intercomExceptions];
_vehicle setVariable [QGVAR(restrictedPositions), _intercomRestrictions];
_vehicle setVariable [QGVAR(numRestrictedPositions), _intercomNumRestricted];
_vehicle setVariable [QGVAR(connectByDefault), _intercomConnectByDefault];
_vehicle setVariable [QGVAR(unitsIntercom), _unitsIntercom];
