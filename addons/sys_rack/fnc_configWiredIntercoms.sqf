/*
 * Author: ACRE2Team
 * Configures rack intercom network availability.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Rack class <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_configWiredIntercoms
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_rack"];

private _type = typeOf _vehicle;

private _intercoms = getArray (_rack >> "intercom");
private _wiredIntercoms = [];

// Set by default to have access to all intercom networks if none was specified
if (_intercoms isEqualTo []) then {
    _wiredIntercoms append (_vehicle getVariable[QEGVAR(sys_intercom,intercomNames), []]);
} else {
    if ("none" in _intercoms) then {
        _wiredIntercoms = [];
    } else {
        {
            private _int = toLower _x;
            private _configuredIntercoms = _vehicle getVariable[QEGVAR(sys_intercom,intercomNames), []];
            if (_int in _configuredIntercoms) then {
                _wiredIntercoms pushBack _x;
            } else {
                WARNING_3("Vehicle type %1 does not have the intercom %2 but the rack %3 can have access to its network. Not adding it.",_type,_int,_rack)
            };
        } forEach _intercoms;
    };
};

_wiredIntercoms
