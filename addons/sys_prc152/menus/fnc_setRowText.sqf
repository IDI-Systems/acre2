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
 * [ARGUMENTS] call acre_sys_prc152_fnc_setRowText
 *
 * Public: No
 */

#ifdef ENABLE_PERFORMANCE_COUNTERS
    BEGIN_COUNTER(setRowText);
#endif

TRACE_1("setRowText",_this);
private _display = uiNamespace getVariable QGVAR(currentDisplay);

params ["_row", "_string", ["_alignment", ALIGN_LEFT]];

private _data = toArray _string;

private _rowCount = 0;
if (_row > 20) then {
    if (_row > 30) then {
        if (_row > 40) then {
            _rowCount = COLUMNS_XXLARGE;
        } else {
            _rowCount = COLUMNS_XLARGE;
        };
    } else {
        _rowCount = COLUMNS_LARGE;
    };
} else {
    _rowCount = COLUMNS_SMALL;
};

private _start = 0;
private _length = count _data;
switch _alignment do {
    case ALIGN_LEFT: {
        _start = 0;
    };
    case ALIGN_RIGHT: {
        _start = _rowCount - _length;
    };
    case ALIGN_CENTER: {
        _start = floor ( (_rowCount - _length) / 2);
    };
};
TRACE_3("setting text",_start,_rowCount,_length);

private _baseId = (_row * 1000) +1;

for "_i" from 0 to (_rowCount -1) do {
    private _id = _baseId + _i;
    private _ctrl = (_display displayCtrl _id);
    _ctrl ctrlSetText "";
    _ctrl ctrlCommit 0;
};

for "_i" from _start to ((_rowCount -1) min (_start+_length-1)) do {
    private _id = _baseId + _i;
    private _ctrl = (_display displayCtrl _id);
    _ctrl ctrlSetText (toString [_data select (_i-_start)]);
    _ctrl ctrlCommit 0;
};

#ifdef ENABLE_PERFORMANCE_COUNTERS
    END_COUNTER(setRowText);
#endif
