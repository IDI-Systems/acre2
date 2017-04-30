/*
 * Author: ACRE2Team
 * Handles the receipt of an attachComponent message.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event Name <STRING>
 * 2: Data <ANY>
 * 3: Radio data <HASH>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * ["ACRE_PRC343_ID_1","attachComponent",["ACRE_PRC343_ID_1",0,1,nil],acre_sys_data_radioData getVariable "ACRE_PRC343_ID_1"] call acre_sys_components_fnc_attachComponentHandler
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_event", "_data", "_radioData", "_eventKind"];

_data params ["_componentId", "_childConnector", "_parentConnector", "_attributes"];
//_childConnector - this is the connector on this event's device
//_parentConnector -  this is the connector on the device being connected


private _connectorData = HASH_GET(_radioData, "acre_radioConnectionData");
if (isNil "_connectorData") then {
    _connectorData = [];
    HASH_SET(_radioData, "acre_radioConnectionData", _connectorData);
};

_connectorData set[_childConnector, [_componentId, _parentConnector, _attributes]];

_this call EFUNC(sys_data,handleSetData);
