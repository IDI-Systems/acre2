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

params ["_componentId"];

private _parentComponentData = HASH_GET(acre_sys_data_radioData,_componentId);
private _return = nil;
if (!isNil "_parentComponentData") then {
    private _parentConnectorData = HASH_GET(_parentComponentData, "acre_radioConnectionData");
    if (!isNil "_parentConnectorData") then {
        _return = [];
        {
            if (!isNil "_x") then {
                PUSH(_return, [ARR_2(_forEachIndex,_x)]);
            };
        } forEach _parentConnectorData;
    };
};
_return;
