/*
	SQF INI Parser

	Description:
	Parses an ini configuration file according to the ini format (mostly).
	Sections are allowed, strings can be quoted or unquoted, and comments
	begin with a ;. Data is returned in a ordered array following the order
	of the ini file. Section names will be strings, and key/value pairs will
	be in an array ([key, val]). No further encapsulation or accesing methods
	are included, that is up to the user. 
	
	A custom error handler can also be passed to the function. The default
	error handler will spit out a hintSilent and a rpt message showing the
	file, line number, and error message.

	Parameter(s):
		1: Path to ini file.
		2: (Optional) A code block/function for error handling.

	Returns:
	Array

	Copyright (c) 2013, IDI-Systems
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met: 

	1. Redistributions of source code must retain the above copyright notice, this
	   list of conditions and the following disclaimer. 
	2. Redistributions in binary form must reproduce the above copyright notice,
	   this list of conditions and the following disclaimer in the documentation
	   and/or other materials provided with the distribution. 

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#include "script_component.hpp"
private ["_path", "_data", "_alpha", "_numeric", "_alphaNumeric", "_special", "_printable", "_lineCount", 
			"_organizedData", "_lines", "_line", "_comment", "_preValue", "_foundEqualSign", "_openString", 
			"_openStringType", "_openSection", "_end", "_char", "_lineData", "_key", "_val", "_foundVal", 
			"_isSection", "_examplePrintable", "_exception", "_errorHandlerFnc"];


/**************************************
 * THIS IS THE DEFAULT ERROR HANDLER
 * YOU CAN PASS AN ALTERNATE ONE TO
 * THE FUNCTION IF YOU WANT.
 */
_errorHandlerFnc = {
	private ["_errorMessage"];
	params ["_file", "_lineCount", "_exception"];
	
	_errorMessage = format["INI Parsing Error: %1@%2: %3", _file, _lineCount, _exception];
	
	hintSilent _errorMessage;
	diag_log text format["%1 %2", diag_tickTime, _errorMessage];
};

params["_path"];

if((count _this) > 1) then {
	_errorHandlerFnc = _this select 1;
};

_alpha = [65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,
		  97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122];	  
_numeric = [48,49,50,51,52,53,54,55,56,57];
_alphaNumeric = _alpha + _numeric;
_special = [45,46,95,43];
_printable = _alphaNumeric + _special;
_printableSpace = _printable + [32];


_data = loadFile _path;
_data = toArray _data;

_lineCount = 0;
_organizedData = [];

try {
	if((count _data) > 10000) then {
		throw "Data length > 10,000 characters.";
	};
	_lines = [];
	_line = "";
	_comment = false;
	_preValue = true;
	_isSection = false;
	_foundEqualSign = false;
	_openString = false;
	_openStringType = -1;
	_openSection = false;
	_lineCount = _lineCount + 1;
	for "_i" from 0 to (count _data) do {
		_end = false;
		if(_i == (count _data)) then {
			_end = true;
		};
		_char = -1;
		if(!_end) then {
			_char = _data select _i;
		};
		if(_end || _char == 13 || _char == 10) then {
			if(_openString) then {
				throw format["No closing %2 found.", _lineCount, toString [_openStringType]];
			};
			if(_line != "") then {
				PUSH(_lines, ARR_2(_lineCount, _line));
			};
			_line = "";
			_comment = false;
			_foundEqualSign = false;
			_preValue = true;
			_lineCount = _lineCount + 1;
			_openStringType = -1;
			_openString = false;
			_isSection = false;
			if(!_end) then {
				if((_data select (_i+1)) == 10 || (_data select (_i+1)) == 13) then {
					_i = _i + 1;
				};
			};
		} else {
			if(!_comment) then {
				if(_line == "" && _char == 59) then {
					_comment = true;
				} else {
					if(_line == "" && _char == 91) then {
						_isSection = true;
					};
					if(_char != 32 && _char != 9 || !_preValue || (_isSection && _char != 9)) then {
						if(_char == 61 && !_foundEqualSign) then {
							_foundEqualSign = true;
						};
						if((_char == 34 || _char == 39) && (_preValue && _foundEqualSign && !_openString)) then {
							_openStringType = _char;
						};
						if(_foundEqualSign && _char != 61) then {
							_preValue = false;
						};
						if(_openStringType != _char) then {
							// _line = _line + "," + str _char;
							_line = _line + toString [_char];
						} else {
							if(!_openString) then {
								_openString = true;
							} else {
								_openString = false;
							};
						};
					};
				};
			};
		};
	};
	{
		_lineData = toArray (_x select 1);
		_lineCount = _x select 0;
		_key = "";
		_val = "";
		_foundVal = false;
		_isSection = false;
		_openSection = false;
		for "_i" from 0 to (count _lineData)-1 do {
			_char = _lineData select _i;
			if(_i == 0 && _char == 91) then {
				_isSection = true;
				_openSection = true;
			};
			if(_isSection) then {
				if(_i == 1 && !(_char in _alphaNumeric)) then {
					throw "Section names must start with a alphanumeric character and not be empty.";
				};
				if(_i > 1 && !(_char in _printableSpace) && _char != 93) then {
					_examplePrintable = "";
					{ _examplePrintable = _examplePrintable + (toString [_x]) + " "; } forEach _special;
					throw format["Section names may only contain alphanumeric characters, spaces, and the following: %1", _examplePrintable];
				};
				if(_i > 0 && _char != 93) then {
					_val = _val + toString [_char];
				} else {
					if(_char == 93) then {
						_openSection = false;
						if(_i != (count _lineData)-1) then {
							throw "Section names must end with a ] character only.";
						};
					};
				};
			} else {
				if(_i == 0 && !(_char in _alphaNumeric)) then {
					throw "Keys must start with a alphanumeric character.";
				};
				if(_i > 1 && !(_char in _printable) && _char != 61 && !_foundVal) then {
					_examplePrintable = "";
					{ _examplePrintable = _examplePrintable + (toString [_x]) + " "; } forEach _special;
					throw format["Found %1 in key name. Key names may only contain alphanumeric characters and the following: %2", toString [_char], _examplePrintable];
				};
				if(_char != 61 || _foundVal) then {
					if(_foundVal) then {
						_val = _val + toString [_char];
					} else {
						_key = _key + toString [_char];
					};
				};
				if(_char == 61 && !_foundVal) then {
					_foundVal = true;
					if(_key == "") then {
						throw "Empty key name found.";
					};
				};
			};
		};
		if(_openSection) then {
			throw "Missing closing ] in section name.";
		};
		if(!_isSection && !_foundVal) then {
			throw "Section names must be wrapped in [ ].";
		};
		if(!_isSection) then {
			PUSH(_organizedData, ARR_2(_key, _val));
		} else {
			PUSH(_organizedData, _val);
		};
	} forEach _lines;
}
catch {
	[_path, _lineCount, _exception] call CALLSTACK(_errorHandlerFnc);
};
_organizedData