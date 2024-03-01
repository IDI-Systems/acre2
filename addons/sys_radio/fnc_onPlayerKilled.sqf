#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles death of unit, primarily for handling local player death.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [player] call acre_sys_radio_fnc_onPlayerKilled
 *
 * Public: No
 */

TRACE_1("",_this);
params ["_unit"];

if (_unit == acre_player) then {
    LOG("acre_player died. resetting all radio info");
    {
        private _radioName = _x;
        acre_player setVariable [_radioName, nil, false];

        // Make sure the GUI state is closed so that other players can open the radio
        [_radioName, false] call FUNC(setRadioOpenState);
    } foreach GVAR(currentRadioList);
    GVAR(currentRadioList) = [];

    [""] call FUNC(setActiveRadio);
};
