/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params["_componentId"];

private _searchedComponents = [];
private _searchFunction = {
    private _returnTree = [];
    params["_componentParentId"];
    PUSH(_searchedComponents, _componentParentId);
    private _componentData = HASH_GET(acre_sys_data_radioData, _componentParentId);

    if(!isNil "_componentData") then {
        private _connectorData = HASH_GET(_componentData, "acre_radioConnectionData");
        if(!isNil "_connectorData") then {
            {
                private _connector = _x;
                private _connectorIndex = _forEachIndex;
                if(!isNil "_connector") then {
                    private _connectedComponent = _connector select 0;
                    private _attributes = _connector select 2;
                    private _componentClass = configFile >> "CfgAcreComponents" >> _connectedComponent;
                    private _componentSimple = getNumber(_componentClass >> "simple");
                    if(_componentSimple == 1) then {
                        PUSH(_returnTree, ARR_3(_connectedComponent, _connectorIndex, []));
                    } else {
                        if(!(_connectedComponent in _searchedComponents)) then {
                            private _ret = [_connectedComponent] call _searchFunction;
                            PUSH(_returnTree, ARR_3(_connectedComponent, _connectorIndex, _ret));
                        };
                    };
                };
            } forEach _connectorData;
        };
    };
    _returnTree;
};
[_componentId] call _searchFunction;
