#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the list of all connectors on a component that are unused.
 *
 * Arguments:
 * 0: Component ID <STRING>
 *
 * Return Value:
 * Connectors array of indexes <ARRAY>
 *
 * Example:
 * ["ACRE_PRC152_ID_1"] call acre_sys_components_fnc_getAllAvailableConnectors
 *
 * Public: No
 */

params ["_componentId"];

private _componentData = HASH_GET(EGVAR(sys_data,radioData),_componentId);
private _return = nil;
if (!isNil "_componentData") then {
    private _connectorData = HASH_GET(_componentData,"acre_radioConnectionData");
    if (!isNil "_connectorData") then {
        _return = [];
        private _componentClass = configFile >> "CfgAcreComponents" >> BASE_CLASS_CONFIG(_componentId);
        private _connectors = getArray (_componentClass >> "connectors");
        {
            if (_forEachIndex < (count _connectorData)) then {
                private _connectorIndexData = _connectorData select _forEachIndex;
                if (isNil "_connectorIndexData") then {
                    _return pushBack _forEachIndex;
                };
            } else {
                _return pushBack _forEachIndex;
            };
        } forEach _connectors;
    };
};
_return;
