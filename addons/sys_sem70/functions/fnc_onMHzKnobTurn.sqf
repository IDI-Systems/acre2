#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem70_fnc_onMHzKnobTurn
 *
 * Public: No
 */

params ["","_key","","","_shift"];

private _isOn = ["getState", "radioOn"] call GUI_DATA_EVENT;
if (_isOn != 1) exitWith {};

GVAR(backlightOn) = true;
GVAR(lastAction) = time;

// Ignore all interaction if radio is not on manual Channel Selection
private _manualChannelSelection = ["getState", "manualChannelSelection"] call GUI_DATA_EVENT;
if (_manualChannelSelection != 1) exitWith {};

//Read out the key pressed (left/right mousebutton) and define the knob position increase/decrease
private _dir = -1;
if (_key == 0) then {
    _dir = 1;
};

//If shift is pressed, perform a step by +-5
if (_shift) then {
    _dir = _dir*5;
};

private _knobPosition = ["getState", "MHzKnobPosition"] call GUI_DATA_EVENT;
private _newKnobPosition = _knobPosition + _dir;

if (_knobPosition != _newKnobPosition) then {
    //Allow a jump over the null position
    if (_newKnobPosition > 49) then {
        _newKnobPosition = 0;
    };
    if (_newKnobPosition < 0) then {
        _newKnobPosition = 49;
    };
    ["setStateCritical", ["MHzKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;

    // We parse a 0 here, because we are in manual mode
    ["setCurrentChannel", GVAR(manualChannel)] call GUI_DATA_EVENT;

    ["Acre_SEMKnob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
