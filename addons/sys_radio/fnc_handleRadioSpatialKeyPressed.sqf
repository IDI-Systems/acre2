#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles pressing the spatial keybind.
 *
 * Arguments:
 * 0: Spatial configuration <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["LEFT"] call acre_sys_radio_fnc_handleRadioSpatialKeyPressed
 *
 * Public: No
 */

params ["_side"];


TRACE_1("GOT SPATIAL KEY PRESS", _side);

if (ACRE_ACTIVE_RADIO == "") exitWith {
    nil
};

private _currentSide = [ACRE_ACTIVE_RADIO] call FUNC(getRadioSpatial);
if (!isNil "_currentSide") then {
    if (_currentSide != _side) then {
        [ACRE_ACTIVE_RADIO, _side] call FUNC(setRadioSpatial);

        [[format [localize LSTRING(radioSetTo), _side]], true] call CBA_fnc_notify;
    };
};
