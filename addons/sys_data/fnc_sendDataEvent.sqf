#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_sendDataEvent
 *
 * Public: No
 */

if (isServer) then {
    _this call FUNC(serverPropDataEvent);
    _this call FUNC(onDataChangeEvent);
} else {
    ACREs = _this;
    publicVariableServer "ACREs";
};
