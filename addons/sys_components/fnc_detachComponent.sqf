/*
 * Author: ACRE2Team
 * Remove component from another component.
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
#include "script_component.hpp"

params["_parentComponentId", "_parentConnector"];

private _return = false;
private _parentComponentClass = configFile >> "CfgAcreComponents" >> (getText(configFile >> "CfgWeapons" >> _parentComponentId >> "acre_baseClass"));

private _parentComponentData = HASH_GET(acre_sys_data_radioData,_parentComponentId);
if(!isNil "_parentComponentData") then {
    private _parentConnectorData = HASH_GET(_parentComponentData, "acre_radioConnectionData");
    if(!isNil "_parentConnectorData") then {
        if((count _parentConnectorData) > _parentConnector) then {
            private _parentConnectedComponentData = _parentConnectorData select _parentConnector;

            private _childComponentId = _parentConnectedComponentData select 0;
            if(isClass(configFile >> "CfgAcreComponents" >> _childComponentId)) then {
                if(count _parentConnectorData > _parentConnector) then {
                    private _test = _parentConnectorData select _parentConnector;
                    if(!isNil "_test") then {
                        [_parentComponentId, "detachComponent", [_parentConnector]] call EFUNC(sys_data,dataEvent);
                        _return = true;
                    };
                };
            } else {
                private _childComponentData = HASH_GET(acre_sys_data_radioData,_childComponentId);

                if(!isNil "_childComponentData") then {
                    private _childConnectorData = HASH_GET(_parentComponentData, "acre_radioConnectionData");
                    private _childConnector = -1;
                    {
                        if((_x select 0) == _parentComponentId && {(_x select 1) == _parentConnector}) exitWith {
                            _childConnector = _forEachIndex;
                        };
                    } forEach _childComponentData;
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
