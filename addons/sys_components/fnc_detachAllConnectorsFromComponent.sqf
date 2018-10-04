#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Removes all connections between two components. This is particularly useful for racks and radios as they may have multiple connections.
 *
 * Arguments:
 * 0: Component ID to remove from <STRING>
 * 1: Connector Index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_VRC110_ID_1","ACRE_PRC152_ID_1"] call acre_sys_components_fnc_detachAllConnectorsFromComponent
 *
 * Public: No
 */

params ["_firstComponentId","_secondComponentId"];

private _firstComponentConnectors = [_firstComponentId] call EFUNC(sys_components,getAllConnectedComponents);

{
    _x params ["_connectorIdx","_connectorData"];
    _connectorData params ["_connectedComponent"];

    if (_connectedComponent == _secondComponentId) then {
        [_firstComponentId, _connectorIdx] call FUNC(detachComponent);
    };
} forEach (_firstComponentConnectors);

private _secondComponentConnectors = [_secondComponentId] call EFUNC(sys_components,getAllConnectedComponents);
{
    _x params ["_connectorIdx","_connectorData"];
    _connectorData params ["_connectedComponent"];

    if (_connectedComponent == _firstComponentId) then {
        [_secondComponentId, _connectorIdx] call FUNC(detachComponent);
    };
} forEach (_secondComponentConnectors);