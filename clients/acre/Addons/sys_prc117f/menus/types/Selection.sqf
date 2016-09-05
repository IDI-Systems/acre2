//#define DEBUG_MODE_FULL
#include "script_component.hpp"

DFUNC(onButtonPress_Selection) = {
	TRACE_1("onButtonPress_Selection", _this);
	private["_currentSelection"];
	params["_menu", "_event"];

	_currentSelection = GET_STATE_DEF("menuSelection", 0);
	TRACE_2("!!!!!!!!!!!!!!!!!!!!!!!!!", _currentSelection, (_event select 0));
	switch (_event select 0) do {
		case 'ENT': {
			private["_value"];
			_value = ((MENU_SELECTION_DISPLAYSET(_menu) select 0) select _currentSelection);

			SCRATCH_SET(GVAR(currentRadioId), MENU_SELECTION_VARIABLE(_menu), _value);
			
			// swap to the parent
			TRACE_1("onButtonPress_Selection: Value saved", _value);
			[MENU_PARENT(_menu)] call FUNC(changeMenu);
		};
		case 'CLR': {
			TRACE_1("onButtonPress_Selection: Value not saved","");
			private _parentMenu = HASH_GET(GVAR(Menus), MENU_PARENT_ID(_menu));
			private _useParent = true;
			
			//If Parent action series -> Go to its parent.
			if (!isNil "_parentMenu" && {MENU_TYPE(_parentMenu) == MENUTYPE_ACTIONSERIES}) then {
				private _pid = MENU_PARENT_ID(_parentMenu);
				if (_pid isEqualType "") then {
					_useParent = false;
					SET_STATE("menuAction", 0);
					[_pid] call FUNC(changeMenu);
				};
			};

			if (_useParent) then {
				[MENU_PARENT_ID(_menu)] call FUNC(changeMenu);
			};
		};
		case '6': {
			if(_currentSelection > 0 ) then {
				_currentSelection = _currentSelection - 1;
				SET_STATE("menuSelection", _currentSelection);
				
				TRACE_1("Decremented", _currentSelection);
				[_menu] call FUNC(renderMenu_Selection);
			};
		};
		case '9': {
			if(_currentSelection+1 < (count (MENU_SELECTION_DISPLAYSET(_menu) select 0) ) ) then {
				_currentSelection = _currentSelection + 1;
				SET_STATE("menuSelection", _currentSelection);
				
				TRACE_1("Incremented", _currentSelection);
				[_menu] call FUNC(renderMenu_Selection);
			};
		};
		default {
			//diag_log text format["!!! UNHANDLED KEY FOR SELECTION"];
		};
	};
};
DFUNC(renderMenu_Selection) = {
	//TRACE_1(QUOTE(FUNC(renderMenu_Number)), _this);
	private["_displaySet", "_value", "_options", "_cursor", "_valueHash"];
	params["_menu"]; // the menu to render is passed
	_displaySet = MENU_SUBMENUS(_menu);
	
	_options = MENU_SELECTION_DISPLAYSET(_menu) select 0;
	_cursor = MENU_SELECTION_DISPLAYSET(_menu) select 1;
	
	_currentSelection = GET_STATE_DEF("menuSelection", 0);
	_value = _options select _currentSelection;
	
	_valueHash = HASH_CREATE;
	HASH_SET(_valueHash, "1", _value);
	
	[] call FUNC(clearDisplay);
	if(!isNil "_displaySet" && _displaySet isEqualType [] && (count _displaySet) > 0) then {
		{
			private["_format", "_renderString"];
			// Data selection row
			[(_x select 0), 
			 (_x select 2),
			 (_x select 1),
			  _valueHash] call FUNC(renderText);
		} forEach MENU_SUBMENUS(_menu);
	};
	
	[ROW_SMALL_1, MENU_PATHNAME(_menu)] call FUNC(renderText);		// Header line
	
	[(_cursor select 0), 
	[(_cursor select 1), 
	(_cursor select 2)], true, ALIGN_CENTER] call FUNC(drawCursor);
};

