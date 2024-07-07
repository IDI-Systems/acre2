#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns all the connected components for a given component ID.
 *
 * Arguments:
 * 0: Component ID <STRING>
 *
 * Return Value:
 * Array of component data, nil if component ID does not exist <ARRAY>
 *
 * Example:
 * ["ACRE_PRC152_ID_1"] call acre_sys_components_fnc_getAllConnectedComponents
 *
 * Public: No
 */

params["_componentId"];

private _parentComponentData = HASH_GET(EGVAR(sys_data,radioData),_componentId);
private _return = nil;
if (!isNil "_parentComponentData") then {
    private _parentConnectorData = HASH_GET(_parentComponentData,"acre_radioConnectionData");
    if (!isNil "_parentConnectorData") then {
        _return = [];
        {
            if (!isNil "_x") then {
                _return pushBack [_forEachIndex,_x];
            };
        } forEach _parentConnectorData;
    };
};
_return;
