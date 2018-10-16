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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

params ["_radioId", "_event", "_eventData", "_radioData"];

private _obj = [_radioId] call EFUNC(sys_radio,getRadioObject);
private _pos = getPosASL _obj;

private _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);
if (_rackId isEqualTo "") then {
    if (_obj isKindOf "Man") then {
        _pos = ATLtoASL (_obj modelToWorld (_obj selectionPosition "RightShoulder"));
    };
} else {
    private _vehicle = [_radioId] call EFUNC(sys_rack,getVehicleFromRack);
    private _position = [_rackId, _vehicle] call EFUNC(sys_rack,getRackPosition);
    if !(_position isEqualTo [0, 0, 0]) then {
        _pos = ATLtoASL (_vehicle modelToWorld _position);
    };
};

_pos;
