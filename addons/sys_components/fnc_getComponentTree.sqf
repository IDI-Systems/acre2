#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the tree of connected components
 *
 * Arguments:
 * 0: Complex component ID <STRING>
 *
 * Return Value:
 * Tree of component data <ARRAY>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_components_fnc_getComponentTree
 *
 * Public: No
 */

params ["_componentId"];

private _searchedComponents = [];
private _searchFunction = {
    private _returnTree = [];
    params ["_componentParentId"];
    _searchedComponents pushBack _componentParentId;
    private _componentData = HASH_GET(EGVAR(sys_data,radioData),_componentParentId);

    if (!isNil "_componentData") then {
        private _connectorData = HASH_GET(_componentData,"acre_radioConnectionData");
        if (!isNil "_connectorData") then {
            {
                private _connector = _x;
                private _connectorIndex = _forEachIndex;
                if (!isNil "_connector") then {
                    _connector params ["_connectedComponent", "", "_attributes"];

                    private _componentClass = configFile >> "CfgAcreComponents" >> _connectedComponent;
                    private _componentSimple = getNumber (_componentClass >> "simple");
                    if (_componentSimple == 1) then {
                        _returnTree pushBack [_connectedComponent, _connectorIndex,[]];
                    } else {
                        if !(_connectedComponent in _searchedComponents) then {
                            private _ret = [_connectedComponent] call _searchFunction;
                            _returnTree pushBack [_connectedComponent, _connectorIndex,_ret];
                        };
                    };
                };
            } forEach _connectorData;
        };
    };
    _returnTree;
};
[_componentId] call _searchFunction;
