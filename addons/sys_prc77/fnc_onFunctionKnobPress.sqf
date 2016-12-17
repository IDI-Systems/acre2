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
 * [ARGUMENTS] call acre_sys_prc77_fnc_onFunctionKnobPress;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_control", "_key"];

//Read out the key pressed (left/right mousebutton) and define the function increase/decrease
private _dir = -1;
if (_key == 0) then {
    _dir = 1;
};

//Read out the currentFunction via DataEvent
private _currentFunction = GET_STATE("function");

//Define and set new function
private _newFunction = ((_currentFunction + _dir) max 0) min 4;
SET_STATE_CRIT("function", _newFunction);

//Handle new function
if (_newFunction != _currentFunction) then {
    ["setOnOffState", 1] call GUI_DATA_EVENT;

    if (_newFunction == 0) then {
        ["setOnOffState", 0] call GUI_DATA_EVENT;
    };
    if (_newFunction == 1) then {
        SET_STATE("squelch", 0);
        SET_STATE("CTCSSRx", 0);
        SET_STATE("CTCSSTx", 0);
    };
    if (_newFunction == 2) then {
        SET_STATE("squelch", 3);
        SET_STATE("CTCSSRx", 150);
        SET_STATE("CTCSSTx", 150);
    };
    // if (_newFunction == 3) then {
        // Retrans
    // };
    if (_newFunction == 4) then {
        private _eh = _control ctrlAddEventHandler ["MouseButtonUp", QUOTE(_this call FUNC(snapbackFunctionKnob))];
    };
    //Play sound and render dialog
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call CALLSTACK(FUNC(render));
};
