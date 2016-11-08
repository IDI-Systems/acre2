/*
 * Author: ACRE2Team
 * Returns the list of all connectors on a component that are unused.
 *
 * Arguments:
 * 0: Component ID <STRING>
 *
 * Return Value:
 * Connectors <ARRAY>
 *
 * Example:
 * ["ACRE_PRC152_ID_1"] call acre_sys_components_fnc_getAllAvailableConnectors
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_componentId"];

private _componentData = HASH_GET(acre_sys_data_radioData,_componentId);
private _return = nil;
if(!isNil "_componentData") then {
    private _connectorData = HASH_GET(_componentData, "acre_radioConnectionData");
    if(!isNil "_connectorData") then {
        _return = [];
        private _baseClass = getText(configFile >> "CfgWeapons" >> _componentId >> "acre_baseClass");
        if (_baseClass == "") then {_baseClass = getText(configFile >> "CfgVehicles" >> _componentId >> "acre_baseClass"); };
        private _componentClass = configFile >> "CfgAcreComponents" >> _baseClass;
        private _connectors = getArray(_componentClass >> "connectors");
        {
            if(_forEachIndex < (count _connectorData)) then {
                private _connectorIndexData = _connectorData select _forEachIndex;
                if(isNil "_connectorIndexData") then {
                    _return pushBack _forEachIndex;
                };
            } else {
                _return pushBack _forEachIndex;
            };
        } forEach _connectors;
    };
};
_return;
