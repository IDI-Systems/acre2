#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of turning the function radio knob and selects the radio mode:
 * off (0), on (1), squelch (2), retrans (3) and lite (4).
 *
 * Arguments:
 * 0: Control UI object <CONTROL>
 * 1: Left or right click identifier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this, 1] call acre_sys_prc77_fnc_onFunctionKnobPress
 *
 * Public: No
 */

params ["_control", "_key"];

// Read out the key pressed (left/right mousebutton) and define the function increase/decrease
private _dir = -1;
if (_key == 0) then {
    _dir = 1;
};

// Read out the currentFunction via DataEvent
private _currentFunction = GET_STATE("function");

// Define and set new function
private _newFunction = ((_currentFunction + _dir) max 0) min 4;
SET_STATE_CRIT("function", _newFunction);

// Handle new function
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
        private _eh = _control ctrlAddEventHandler ["MouseButtonUp", {call FUNC(snapbackFunctionKnob)}];
    };
    //Play sound and render dialog
    ["Acre_GenericClick", [0, 0, 0], [0, 0, 0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call CALLSTACK(FUNC(render));
};
