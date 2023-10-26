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
 * [ARGUMENTS] call acre_sys_sem70_fnc_onNetworkKnobTurn
 *
 * Public: No
 */

params ["_ctrl","_key"];

private _ctrlIDC = ctrlIDC _ctrl;

private _isOn = ["getState", "radioOn"] call GUI_DATA_EVENT;
if (_isOn != 1) exitWith {};

GVAR(backlightOn) = true;
GVAR(lastAction) = time;

// Ignore all interaction if radio is on manual Channel Selection
private _manualChannelSelection = ["getState", "manualChannelSelection"] call GUI_DATA_EVENT;
if (_manualChannelSelection == 1) exitWith {};

//Read out the key pressed (left/right mousebutton) and define the knob position increase/decrease
private _dir = -1;
if (_key == 0) then {
    _dir = 1;
};

private _knobPosition = ["getState", "NetworkKnobPosition"] call GUI_DATA_EVENT;

switch (_ctrlIDC) do {
    case (209): {
        private _subPos = _knobPosition param [0];
        _subPos = _subPos + _dir;

        if (_subPos > 9) then {
            _subPos = 0;
        };
        if (_subPos < 0) then {
            _subPos = 9;
        };

        _knobPosition set [0, _subPos];
    };

    case (210): {
        private _subPos = _knobPosition param [1];
        _subPos = _subPos + _dir;

        if (_subPos > 9) then {
            _subPos = 0;
        };
        if (_subPos < 0) then {
            _subPos = 9;
        };

        _knobPosition set [1, _subPos];
    };

    case (211): {
        private _subPos = _knobPosition param [2];
        _subPos = _subPos + _dir;

        if (_subPos > 9) then {
            _subPos = 0;
        };
        if (_subPos < 0) then {
            _subPos = 9;
        };

        _knobPosition set [2, _subPos];
    };
};

["setState", ["NetworkKnobPosition", _knobPosition]] call GUI_DATA_EVENT;

[] call FUNC(setNetworkID);

["Acre_SEMKnob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call FUNC(render);
