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

private _config = configOf _vehicle;

// Configure what intercom networks the infantry phone has access to
private _infantryPhoneIntercom = getArray (_config >> "acre_infantryPhoneIntercom") apply {toLower _x};
private _infantryPhoneControlActions = getArray (_config >> "acre_infantryPhoneControlActions") apply {toLower _x};
private _infantryPhoneDisableRinging = (getNumber (_config >> "acre_infantryPhoneDisableRinging")) == 1;
private _infantryPhoneCustomRinging = getArray (_config >> "acre_infantryPhoneCustomRinging");

// Set by default to have access to all intercom networks if none was specified
private _configHelper = {
    params ["_configArray", "_configEntry"];

    private _returnArray = [];
    if (_configArray isEqualTo []) then {
        WARNING_1("No intercom networks specified for %1 - assuming all intercoms can be reached with the infantry phone",typeOf _vehicle);
        _returnArray pushBack (_vehicle getVariable [QGVAR(intercomNames), []]);
    } else {
        // Check for a valid configuration
        if ("all" in _configArray) then {
            if (count _configArray != 1) then {
                WARNING_2("%1 has %2 entry with the all wildcard in combination with other entries - all intercoms will be made available",typeOf _vehicle,_configEntry);
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
                    WARNING_3("Intercom %1 in %2 is not found as a valid intercom identifier for %3",_x,_configEntry,typeOf _vehicle);
                };
            } forEach _configArray;
        };
    };

    _returnArray
};

_infantryPhoneIntercom = [_infantryPhoneIntercom, "acre_infantryPhoneIntercom"] call _configHelper;
_infantryPhoneControlActions = [_infantryPhoneControlActions, "acre_infantryPhoneControlActions"] call _configHelper;

_vehicle setVariable [QGVAR(infantryPhoneIntercom), _infantryPhoneIntercom];
_vehicle setVariable [QGVAR(infPhoneDisableRinging), _infantryPhoneDisableRinging];
_vehicle setVariable [QGVAR(infantryPhoneControlActions), _infantryPhoneControlActions];

if (_infantryPhoneCustomRinging isNotEqualTo []) then {
    if (_infantryPhoneDisableRinging) then {
        WARNING_2("Ringing functionality disabled despite having a custom ringing tone entry %1 for %2",_infantryPhoneCustomRinging,typeOf _vehicle);
    } else {
        if (count _infantryPhoneCustomRinging != 5) then {
            WARNING_2("Badly formatted entry acre_infantryPhoneCustomRinging for %1 - should have 5 arguments but has %2",typeOf _vehicle,count _infantryPhoneCustomRinging);
        } else {
            _vehicle setVariable [QGVAR(infPhoneCustomRinging), _infantryPhoneCustomRinging];
        };
    };
};

// Hook for third party mods with actions when picking returning infantry phone
private _eventInfantryPhone = getText (_config >> "acre_eventInfantryPhone");
if (_eventInfantryPhone != "") then {
    _vehicle setVariable [QGVAR(eventInfantryPhone), _eventInfantryPhone];
};
