//#define DEBUG_MODE_FULL
#include "script_component.hpp"

BEGIN_COUNTER(renderText);

TRACE_1("renderText", _this);

params["_row", "_text", ["_alignment", ALIGN_LEFT]];

if((count _this) > 3) then {
	private["_hash"];
	_hash = _this select 3;
	_text = [_text, _hash] call FUNC(formatText);
};

[_row, _text, _alignment] call FUNC(setRowText);

END_COUNTER(renderText);