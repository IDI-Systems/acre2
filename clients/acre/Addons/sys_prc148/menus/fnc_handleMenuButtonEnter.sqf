//fnc_handleMenuButtonEnter.sqf
#include "script_component.hpp"

private ["_menuEntry", "_format", "_formatLength", "_formatArray", "_x", "_valLength", "_i", "_length", "_call", "_newValue"];
_menuEntry = (GVAR(currentMenu) select (GVAR(entryMap) select 0)) select (GVAR(entryMap) select 1);
if(!GET_STATE(editEntry)) then {
	SET_STATE(editEntry, true);
	_menuEntry = (GVAR(currentMenu) select (GVAR(entryMap) select 0)) select (GVAR(entryMap) select 1);
	_menuEntry params ["", "_value", "_row", "_range", "_type"];
	
	switch _type do {
		case MENU_TYPE_TEXT: {
			SET_ENTRY_INDEX(0);
			SET_STATE(currentEditEntry, _value);
		};
		case MENU_TYPE_NUM: {
			_format = _menuEntry select 6;
			
			_formatLength = 0;
			_formatArray = toArray _format;
			{
				if(toString [_x] == "#") then {
					_formatLength = _formatLength + 1;
				};
			} forEach _formatArray;
			_valLength = (count (toArray _value));
			//acre_player sideChat format["v: %1 f: %2", _valLength, _formatLength];
			if(_valLength < _formatLength) then {
				for "_i" from 1 to _formatLength - _valLength do {
					//acre_player sideChat "AA!";
					_value = " " + _value;
				};
			};
			//acre_player sideChat format["VAL: '%1'", _value];
			_length = (count (toArray _value))-1;
			SET_ENTRY_INDEX(_length);
			SET_STATE(currentEditEntry, _value);
		};
		case MENU_TYPE_LIST: {
			SET_STATE(currentEditEntry, _value);
		};
		case MENU_TYPE_MENU: {
			_call = _menuEntry select 5;
			_newValue = GET_STATE(currentEditEntry);
			[_newValue, _menuEntry] call _call;
			SET_STATE(editEntry, false);
			SET_STATE(currentEditEntry, "")
		};
	};
} else {
	//acre_player sideChat "BOOP SHABOOP";
	_call = _menuEntry select 5;
	_newValue = GET_STATE(currentEditEntry);
	[_newValue, _menuEntry] call _call;
	SET_STATE(editEntry, false);
	SET_STATE(currentEditEntry, "")
	
};
