//#define DEBUG_MODE_FULL
#include "script_component.hpp"

TRACE_1("setRowText", _this);	
private ["_display", "_data", "_rowCount", "_baseId", "_id", "_i", "_length", "_start", "_tmp"];
_display = uiNamespace getVariable QUOTE(GVAR(currentDisplay));

params["_row", "_string", ["_alignment", ALIGN_LEFT]];
_data = toArray _string;

_rowCount = 0;
if(_row > 20) then {
	if(_row > 30) then {
		if(_row > 40) then {
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

_start = 0;
_length = count _data;
switch _alignment do {
	case ALIGN_LEFT: {
		_start = 0;
	};
	case ALIGN_RIGHT: {
		_start = _rowCount - _length;
	};
	case ALIGN_CENTER: {
		if(_length < _rowCount-1) then {
			_start = floor ( (_rowCount - _length) / 2);
		} else {
			_start = 0;
		};
	};
}; 
TRACE_3("setting text", _start, _rowCount, _length);

_baseId = (_row * 1000) +1;

_i = 0;
while { _i < _rowCount} do {
	_id = _baseId + _i;
	(_display displayCtrl _id) ctrlSetText "";
	(_display displayCtrl _id) ctrlCommit 0;
	_i = _i + 1;
};


_i = 0;
_tmp = _start;
while { _tmp < _rowCount && _i < _length} do {
	_id = _baseId + _tmp;
	(_display displayCtrl _id) ctrlSetText (toString [_data select _i]);
	(_display displayCtrl _id) ctrlCommit 0;
	
	_tmp = _tmp + 1;
	_i = _i + 1;
};

