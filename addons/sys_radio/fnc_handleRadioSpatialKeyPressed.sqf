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

params ["_side"];


TRACE_1("GOT SPATIAL KEY PRESS", _side);

if (ACRE_ACTIVE_RADIO == "") exitWith {
    nil
};

private _currentSide = [ACRE_ACTIVE_RADIO] call FUNC(getRadioSpatial);
if (!isNil "_currentSide") then {
    if (_currentSide != _side) then {
        [ACRE_ACTIVE_RADIO, _side] call FUNC(setRadioSpatial);

        [format["Radio set to %1", _side]] call EFUNC(sys_core,displayNotification);
    };
};
