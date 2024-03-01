#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Send a message to a component.
 *
 * Arguments:
 * 0: Parent component class <STRING>
 * 1: Connector ID <NUMBER>
 * 2: Message <ANY>
 *
 * Return Value:
 * Message sent <BOOL>
 *
 * Example:
 * ["ACRE_PRC343_ID_1",0,"hello"] call acre_sys_components_fnc_sendComponentMessage
 *
 * Public: No
 */

params ["_parentComponentId","_parentConnector", "_message"];

private _return = false;

private _parentComponentData = HASH_GET(EGVAR(sys_data,radioData),_parentComponentId);
if (!isNil "_parentComponentData") then {
    private _parentConnectorData = HASH_GET(_parentComponentData,"acre_radioConnectionData");
    if (!isNil "_parentConnectorData") then {
        if ((count _parentConnectorData) > _parentConnector) then {
            private _parentConnectedComponentData = _parentConnectorData select _parentConnector;

            private _childComponentId = _parentConnectedComponentData select 0;
            private _childComponentData = HASH_GET(EGVAR(sys_data,radioData),_childComponentId);
            if (!isNil "_childComponentData") then {
                private _childConnectorData = HASH_GET(_parentComponentData,"acre_radioConnectionData");
                private _childConnector = -1;
                {
                    if ((_x select 0) == _parentComponentId && {(_x select 1) == _parentConnector}) exitWith {
                        _childConnector = _forEachIndex;
                    };
                } forEach _childComponentData;
                if (_childConnector != -1) then {
                    [_childComponentId, "handleComponentMessage", [_childConnector, _message, _parentComponentId, _parentConnector]] call EFUNC(sys_data,dataEvent);
                    _return = true;
                };
            };
        };
    };
};
_return;
