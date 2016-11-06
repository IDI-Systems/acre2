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

params ["","_key"];

private _isOn = ["getState", "radioOn"] call GUI_DATA_EVENT;
if (_isOn isEqualTo 1) then {
    GVAR(backlightOn) = true;
    GVAR(lastAction) = time;
};

private _currentDirection = -1;
if(_key == 0) then {
    // left click
    _currentDirection = 1;
};

private _knobPosition = ["getState", "functionKnobPosition"] call GUI_DATA_EVENT;
private _newKnobPosition = ((_knobPosition + _currentDirection) max 0) min 4;

if(_knobPosition != _newKnobPosition) then {
    ["setState", ["functionKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;

    switch _newKnobPosition do {
        case 0: {
            // This is reserved for Relais Mode (AKW)
        };

        case 1: {
            // Automatic Channel Selection
            ["setState", ["manualChannelSelection",0]] call GUI_DATA_EVENT;
            private _knobPosition = ["getState", "MemorySlotKnobPosition"] call GUI_DATA_EVENT;
            ["setCurrentChannel", _knobPosition] call GUI_DATA_EVENT;
        };

        case 2: {
            // Manual Channel Selection
            ["setState", ["manualChannelSelection",1]] call GUI_DATA_EVENT;
            ["setCurrentChannel", GVAR(manualChannel)] call GUI_DATA_EVENT;
        };

        case 3: {
            // This is reserved for HW without Squelch
        };

        case 4: {
            // This is reserved for Relais Mode (HW)
        };
    };

    ["Acre_SEM70Knob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
