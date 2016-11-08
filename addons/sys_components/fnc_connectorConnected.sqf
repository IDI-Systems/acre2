/*
 * Author: ACRE2Team
 * Checks if a component is attached to the connector
 *
 * Arguments:
 * 0: Component ID <STRING>
 * 1: Connector index <NUMBER>
 *
 * Return Value:
 * Is component attached to the component <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC152_ID_1",0] call acre_sys_components_fnc_connectorConnected
 *
 * Public: No
 */
#include "script_component.hpp"

params["_componentId","_connector"];

private _componentData = HASH_GET(acre_sys_data_radioData, _componentId);

private _return = false;
if(!isNil "_componentData") then {
    if(_connector < (count _componentData)) then {
        private _test = _componentData select _connector;
        if(!isNil "_test") then {
            _return = true;
        };
    };
};
_return;
