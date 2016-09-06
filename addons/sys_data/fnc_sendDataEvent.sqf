/*
 * Author: AUTHOR
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

if(isServer) then {
    _this call FUNC(serverPropDataEvent);
    _this call FUNC(onDataChangeEvent);
} else {
    ACREs = _this;
    publicVariableServer "ACREs";
};
