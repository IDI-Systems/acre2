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

private ["_obj", "_pos"];
params["_radioId", "_event", "_eventData", "_radioData"];

_obj = RADIO_OBJECT(_radioId);
_pos = getPosASL _obj;
if(_obj isKindOf "Man") then {
    _pos = ATLtoASL (_obj modelToWorld (_obj selectionPosition "RightShoulder"));
};

_pos;
