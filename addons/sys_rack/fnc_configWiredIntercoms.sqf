#include "script_component.hpp"
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

params ["_vehicle", "_rack"];

private _intercoms = (getArray (_rack >> "intercom")) apply {toLower _x};
private _wiredIntercoms = [];

// Set by default to have access to all intercom networks if none was specified
if (_intercoms isEqualTo [] || {"none" in _intercoms}) then {
    _wiredIntercoms = [];
} else {
    if ("all" in _intercoms) then {
        {
            _wiredIntercoms pushBack (_x select 0);
        } forEach (_vehicle getVariable [QEGVAR(sys_intercom,intercomNames), []]);
    } else {
        {
            private _int = _x;
            private _configuredIntercoms = _vehicle getVariable [QEGVAR(sys_intercom,intercomNames), []];
            if (_int in (_configuredIntercoms select 0)) then {
                _wiredIntercoms pushBack _x;
            } else {
                WARNING_3("No intercom %1 defined but rack %2 can have access to its network for %3 - skipping",_int,_rack,typeOf _vehicle)
            };
        } forEach _intercoms;
    };
};

_wiredIntercoms
