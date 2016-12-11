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

BEGIN_COUNTER(renderText);

TRACE_1("renderText", _this);

params ["_row", "_text", ["_alignment", ALIGN_LEFT]];

if ((count _this) > 3) then {
    private _hash = _this select 3;
    _text = [_text, _hash] call FUNC(formatText);
};

[_row, _text, _alignment] call FUNC(setRowText);

END_COUNTER(renderText);
