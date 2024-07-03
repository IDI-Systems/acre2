#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Removes a component from the specified connector, handles both simple and complex components.
 *
 * Arguments:
 * 0: Component ID to remove from <STRING>
 * 1: Connector Index <NUMBER>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * ["ACRE_PRC152_ID_1",0] call acre_sys_components_fnc_detachComponent
 *
 * Public: No
 */

params ["_parentComponentId", "_parentConnector"];

private _return = false;
private _baseClass = [_parentComponentId] call EFUNC(sys_radio,getRadioBaseClassname);
if (_baseClass == "") then {_baseClass = getText (configFile >> "CfgVehicles" >> _parentComponentId >> "acre_baseClass");};

private _parentComponentClass = configFile >> "CfgAcreComponents" >> _baseClass;

private _parentComponentData = HASH_GET(EGVAR(sys_data,radioData),_parentComponentId);
if (!isNil "_parentComponentData") then {
    private _parentConnectorData = HASH_GET(_parentComponentData,"acre_radioConnectionData");
    if (!isNil "_parentConnectorData") then {
        if ((count _parentConnectorData) > _parentConnector) then {
            private _parentConnectedComponentData = _parentConnectorData select _parentConnector;

            private _childComponentId = _parentConnectedComponentData select 0;
            private _config = configFile >> "CfgAcreComponents" >> _childComponentId;

            if (isClass _config) then { // Is Simple component
                if (count _parentConnectorData > _parentConnector) then {
                    private _test = _parentConnectorData select _parentConnector;
                    if (!isNil "_test") then {
                        [_parentComponentId, "detachComponent", [_parentConnector]] call EFUNC(sys_data,dataEvent);
                        _return = true;
                    };
                };
            } else {
                if(HASH_HASKEY(EGVAR(sys_data,radioData),_childComponentId)) then { // Is Complex Component
                    private _components = [_childComponentId] call FUNC(getAllConnectedComponents);
                    private _childConnector = -1;
                    {
                        _x params ["_idx","_data"];

                        if (_data select 0 == _parentComponentId) exitWith { _childConnector = _idx;};
                    } forEach _components; //_childComponentData;
                    if (_childConnector != -1) then {
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
