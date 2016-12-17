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

params ["_radioId","_event", "_data", "_radioData", "_eventKind"];

private _childConnector    = _data select 0; // this is the connector on this event's device

private _connectorData = HASH_GET(_radioData, "acre_radioConnectionData");
if (isNil "_connectorData") then {
    _connectorData = [];
    HASH_SET(_radioData, "acre_radioConnectionData", _connectorData);
};

_connectorData set[_childConnector, nil];

_this call EFUNC(sys_data,handleSetData);
