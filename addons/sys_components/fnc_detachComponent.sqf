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

params["_parentComponentId", "_parentConnector"];


private _return = false;
private _baseClass = getText(configFile >> "CfgWeapons" >> _parentComponentId >> "acre_baseClass");
if (_baseClass == "") then {_baseClass = getText(configFile >> "CfgVehicles" >> _componentId >> "acre_baseClass"); };

private _parentComponentClass = configFile >> "CfgAcreComponents" >> _baseClass;

private _parentComponentData = HASH_GET(acre_sys_data_radioData,_parentComponentId);
if(!isNil "_parentComponentData") then {
    private _parentConnectorData = HASH_GET(_parentComponentData, "acre_radioConnectionData");
    if(!isNil "_parentConnectorData") then {
        if((count _parentConnectorData) > _parentConnector) then {
            private _parentConnectedComponentData = _parentConnectorData select _parentConnector;

            private _childComponentId = _parentConnectedComponentData select 0;
            private _config = configFile >> "CfgAcreComponents" >> _childComponentId;

            if(isClass(_config)) then { // Is Simple component
                if(count _parentConnectorData > _parentConnector) then {
                    private _test = _parentConnectorData select _parentConnector;
                    if(!isNil "_test") then {
                        [_parentComponentId, "detachComponent", [_parentConnector]] call EFUNC(sys_data,dataEvent);
                        _return = true;
                    };
                };
            } else {
                if(HASH_HASKEY(acre_sys_data_radioData,_childComponentId)) then { // Is Complex Component
                    private _components = [_childComponentId] call FUNC(getAllConnectedComponents);
                    private _childConnector = -1;
                    {
                        _x params ["_idx","_data"];

                        if (_data select 0 == _parentComponentId) exitWith { _childConnector = _idx;};
                    } forEach _components; //_childComponentData;
                    if(_childConnector != -1) then {
                        [_parentComponentId, "detachComponent", [_parentConnector]] call EFUNC(sys_data,dataEvent);
                        [_childComponentId, "detachComponent", [_childConnector]] call EFUNC(sys_data,dataEvent);
                        _return = true;
                    };
                };
            };
        };
    };
};
_return;
