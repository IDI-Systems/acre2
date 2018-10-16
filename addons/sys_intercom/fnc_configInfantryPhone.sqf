#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Configures infantry phone intercom network availability.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_configInfantryPhone
 *
 * Public: No
 */

params ["_vehicle"];

private _type = typeOf _vehicle;

// Configure what intercom networks the infantry phone has access to
private _infantryPhoneIntercom = getArray (configFile >> "CfgVehicles" >> _type >> "acre_infantryPhoneIntercom") apply {toLower _x};
private _infantryPhoneControlActions = getArray (configFile >> "CfgVehicles" >> _type >> "acre_infantryPhoneControlActions") apply {toLower _x};
private _infantryPhoneDisableRinging = (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_infantryPhoneDisableRinging")) == 1;
private _infantryPhoneCustomRinging = getArray (configFile >> "CfgVehicles" >> _type >> "acre_infantryPhoneCustomRinging");

// Set by default to have access to all intercom networks if none was specified
private _configHelper = {
    params ["_type", "_configArray", "_configEntry"];

    private _returnArray = [];
    if (_configArray isEqualTo []) then {
        WARNING_2("No intercom networks specified in %1 for vehicle type %2. Assuming all intercoms can be reached with the infantry phone",_type);
        _returnArray pushBack (_vehicle getVariable [QGVAR(intercomNames), []]);
    } else {
        // Check for a valid configuration
        if ("all" in _configArray) then {
            if (count _configArray != 1) then {
                WARNING_2("Vehicle type %1 has %2 entry with the all wildcard in combination with other entries. All intercoms will be made available",_type,_configEntry);
            };

            _returnArray append (_vehicle getVariable [QGVAR(intercomNames), []]);
        } else {
            private _found = false;
            private _intercom = _vehicle getVariable [QGVAR(intercomNames), []];
            {
                private _entry = _x;
                {
                    if (_entry in _x) exitWith {
                        _returnArray pushBackUnique _x;
                        _found = true;
                    }
                } forEach _intercom;
                if (!_found) then {
                    WARNING_3("Intercom %1 in %2 for vehicle type %3 is not found as a valid intercom identifier",_x,_configEntry,_type);
                };
            } forEach _configArray;
        };
    };

    _returnArray
};

_infantryPhoneIntercom = [_type, _infantryPhoneIntercom, "acre_infantryPhoneIntercom"] call _configHelper;
_infantryPhoneControlActions = [_type, _infantryPhoneControlActions, "acre_infantryPhoneControlActions"] call _configHelper;

_vehicle setVariable [QGVAR(infantryPhoneIntercom), _infantryPhoneIntercom];
_vehicle setVariable [QGVAR(infPhoneDisableRinging), _infantryPhoneDisableRinging];
_vehicle setVariable [QGVAR(infantryPhoneControlActions), _infantryPhoneControlActions];

if !(_infantryPhoneCustomRinging isEqualTo []) then {
    if (_infantryPhoneDisableRinging) then {
        WARNING_2("Vehicle type %1 has the ringing functionality disabled despite having a custom ringing tone entry %2",_type,_infantryPhoneCustomRinging);
    } else {
        if (count _infantryPhoneCustomRinging != 5) then {
            WARNING_2("Badly formatted entry acre_infantryPhoneCustomRinging for vehicle type %1. It should have 5 arguments but it has %2.",_type,count _infantryPhoneCustomRinging);
        } else {
            _vehicle setVariable [QGVAR(infPhoneCustomRinging), _infantryPhoneCustomRinging];
        };
    };
};

// Hook for third party mods with actions when picking returning infantry phone
private _eventInfantryPhone = getText (configFile >> "CfgVehicles" >> _type >> "acre_eventInfantryPhone");
if (_eventInfantryPhone != "") then {
    _vehicle setVariable [QGVAR(eventInfantryPhone), _eventInfantryPhone];
};
