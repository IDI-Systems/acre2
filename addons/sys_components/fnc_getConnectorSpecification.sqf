#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns an array with the specification of the connectors for a component.
 *
 * Arguments:
 * 0: Component ID <STRING>
 *
 * Return Value:
 * Array of connector data <ARRAY>
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_components_fnc_getConnectorSpecification
 *
 * Public: No
 */

params ["_componentId"];

private _componentData = HASH_GET(EGVAR(sys_data,radioData),_componentId);
private _return = nil;
if(!isNil "_componentData") then {
    private _connectorData = HASH_GET(_componentData,"acre_radioConnectionData");
    if(!isNil "_connectorData") then {
        private _componentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_componentId);
        private _connectors = getArray(_componentClass >> "connectors");
        _return = _connectors;
    };
};
_return;
