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
 * [ARGUMENTS] call acre_sys_prc152_fnc_defaultButtonPress
 *
 * Public: No
 */

params ["_menu", "_event"];

private _ret = false;

private _dir = _event select 2;
if (_dir == 0) then {
    _dir = 1;
} else {
    if (_dir == 1) then {
        _dir = -1;
    };
};

private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
TRACE_2("defaultButtonPress",_display,_event);
switch (_event select 0) do {
    case 'VOLUME': {
        private _volume = GET_STATE("volume");
        TRACE_2("Volume Before",_volume,_dir);
        _volume = ( (_volume * 10) + _dir) / 10;
        TRACE_1("Volume After",_volume);

        if (_volume > 1) then {
            _volume = 1.0;
        };
        if (_volume < 0) then {
            _volume = 0;
        };
        SET_STATE("volume",_volume);
        ["setVolume", _volume] call GUI_DATA_EVENT;
    };
    case 'KNOB': {
        // Knob was clicked
        private _knobPositionOld = GET_STATE_DEF("knobPosition",1);
        TRACE_2("Knob Press",_knobPositionOld,_dir);

        ///////////////////////
        private _knobPosition = _knobPositionOld + _dir;
        if (_knobPosition > 5) then {
            _knobPosition = 5;
        };
        if (_knobPosition < 0) then {
            _knobPosition = 0;
        };

        TRACE_1("New knob position",_knobPosition);
        SET_STATE("knobPosition",_knobPosition);

        _this call FUNC(changeMode);
    };
};

_ret
