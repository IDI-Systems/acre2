#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns an array with data for all its connectors. Nil values will be given for unused connectors.
 *
 * Arguments:
 * 0: Component ID <STRING>
 *
 * Return Value:
 * Connector data <ARRAY>
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_components_fnc_getAllConnectors
 *
 * Public: No
 */

params["_componentId"];

private _componentData = HASH_GET(EGVAR(sys_data,radioData),_componentId);
private _return = nil;
if (!isNil "_componentData") then {
    private _connectorData = HASH_GET(_componentData,"acre_radioConnectionData");
    if(!isNil "_connectorData") then {
        _return = [];
        private _componentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_componentId);
        private _connectors = getArray (_componentClass >> "connectors");
        _return resize (count _connectors);
        {
            _return set [_forEachIndex, _x];
        } forEach _connectorData;
    };
};
_return;
