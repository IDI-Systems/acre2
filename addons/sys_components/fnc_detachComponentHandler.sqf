/*
 * Author: ACRE2Team
 * Handles the detachment of a component.
 *
 * Arguments:
 * 0: Complex Component Id <STRING>
 * 1: Event type <STRING>
 * 2: Data <ARRAY>
 * 3: Radio data for the specified radio <HASH>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1","detachComponent",[0],acre_sys_data_radioData getVariable "ACRE_PRC343_ID_1"] call acre_sys_components_fnc_detachComponentHandler
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId","_event", "_data", "_radioData", "_eventKind"];

private _childConnector = _data select 0; // this is the connector on this event's device

private _connectorData = HASH_GET(_radioData, "acre_radioConnectionData");
if (isNil "_connectorData") then {
    _connectorData = [];
    HASH_SET(_radioData, "acre_radioConnectionData", _connectorData);
};

_connectorData set[_childConnector, nil];

_this call EFUNC(sys_data,handleSetData);
