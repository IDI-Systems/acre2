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
 * [ARGUMENTS] call acre_sys_components_fnc_sendComponentMessage
 *
 * Public: No
 */
#include "script_component.hpp"

private ["_parentComponentId", "_parentConnector"]; // UNDEFINED (was like this orginally), TODO: FIX

params["_componentId","_connectorId", "_message"];

private _return = false;

private _parentComponentData = HASH_GET(acre_sys_data_radioData,_parentComponentId);
if(!isNil "_parentComponentData") then {
    private _parentConnectorData = HASH_GET(_parentComponentData, "acre_radioConnectionData");
    if(!isNil "_parentConnectorData") then {
        if((count _parentConnectorData) > _parentConnector) then {
            private _parentConnectedComponentData = _parentConnectorData select _parentConnector;

            private _childComponentId = _parentConnectedComponentData select 0;
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
                    [_childComponentId, "handleComponentMessage", [_childConnector, _message, _componentId, _connectorId]] call EFUNC(sys_data,dataEvent);
                    _return = true;
                };
            };
        };
    };
};
_return;
