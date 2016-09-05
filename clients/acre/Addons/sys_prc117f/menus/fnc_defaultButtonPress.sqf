//#define DEBUG_MODE_FULL
#include "script_component.hpp"
private["_ret", "_dir", "_knobPosition"];
params["_menu", "_event"];

_ret = false;


_display = uiNamespace getVariable [QUOTE(GVAR(currentDisplay)), nil];
TRACE_2("defaultButtonPress", _display, _event);
switch (_event select 0) do {
	case 'VOLUME_UP': {
		_volume = GET_STATE("volume");
		_volume = _volume + 0.1;
		if(_volume > 1) then {
			_volume = 1.0;
		};
		["setVolume", _volume] call GUI_DATA_EVENT;
	};
	case 'VOLUME_DOWN': {
		_volume = GET_STATE("volume");
		_volume = _volume - 0.1;
		if(_volume < 0) then {
			_volume = 0;
		};
		["setVolume", _volume] call GUI_DATA_EVENT;
	};
	case 'MODE_KNOB': {
		// Knob was clicked
		_knobPositionOld = GET_STATE_DEF("knobPosition", 1);
		_dir = _event select 2;
		if(_dir == 0) then {
			_dir = 1;
		} else {
			if(_dir == 1) then {
				_dir = -1;
			};
		};
		TRACE_2("Knob Press", _knobPositionOld, _dir);

		///////////////////////
		_knobPosition = _knobPositionOld + _dir;
		if(_knobPosition > 7) then {
			_knobPosition = 7;
		};
		if(_knobPosition < 0) then {
			_knobPosition = 0;
		};

		TRACE_1("New knob position", _knobPosition);
		SET_STATE("knobPosition", _knobPosition);

		_this call FUNC(changeMode);
	};
};

_ret