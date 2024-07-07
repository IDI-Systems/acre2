#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Indicates whether a component has been connected to the specified componant on a particular connector.
 *
 * Arguments:
 * 0: Component ID <STRING>
 * 1: Connector Index <NUMBER>
 *
 * Return Value:
 * Connected <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC343_ID_1",0] call acre_sys_components_fnc_connectorConnected
 *
 * Public: No
 */

params ["_componentId", "_connector"];

private _componentData = HASH_GET(EGVAR(sys_data,radioData),_componentId); // Get Radio Data
if (isNil "_componentData") exitWith {false};
_componentData = HASH_GET(_componentData,"acre_radioConnectionData"); // Get Connection Data
if (isNil "_componentData") exitWith {false};

private _return = false;
if (_connector < (count _componentData)) then {
    private _test = _componentData select _connector;
    if (!isNil "_test") then {
        _return = true;
    };
};

_return
