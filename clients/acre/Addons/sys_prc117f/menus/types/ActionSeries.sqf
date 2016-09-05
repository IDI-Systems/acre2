//#define DEBUG_MODE_FULL
#include "script_component.hpp"

DFUNC(onButtonPress_ActionSeries) = {
	TRACE_1("onButtonPress_List", _this);
	private["_selectedMenu", "_currentSelection"];
	params["_menu", "_event"];
	
	ERROR("This shouldnt hit", "This should not have been reached");
};

DFUNC(renderMenu_ActionSeries) = {
	TRACE_1("renderMenu_ActionSeries", _this);
	private["_events", "_subMenu"];
	params["_menu"];

	// Its an action list of things to do in series, 
	// which can be action menu types. Either way, they always bail back to us once completed
	_currentAction = GET_STATE_DEF("menuAction", 0);

	if(_currentAction < (count MENU_SUBMENUS(_menu)) ) then { 
		// Annnnnd call it
		if(_currentAction > 0) then {
			_subMenu = MENU_SUBMENUS_ITEM(_menu, _currentAction-1);
			[_subMenu] call FUNC(callSingleActionCompleteFunctor);
		};
		
		_saveAction = -1;
		if(_currentAction < (count MENU_SUBMENUS(_menu)) ) then { 
			_subMenu = MENU_SUBMENUS_ITEM(_menu, _currentAction);
			TRACE_1("ACTIONS INCREMENTING", _currentAction);
			_saveAction = _currentAction;
			
			[_subMenu] call FUNC(changeMenu);
		};
		
		_currentAction = _currentAction + 1;
		SET_STATE("menuAction", _currentAction);
		
		if(_saveAction+1 != _currentAction) then {
			_this call FUNC(renderMenu_ActionSeries);
		};
	} else {
		TRACE_1("ACTIONS COMPLETE", _currentAction);
		// Call the action completion function
		
		SET_STATE("menuAction", 0);
		TRACE_1("Calling", MENU_ACTION_SERIESCOMPLETE(_menu));
		_ret = [MENU_ACTION_SERIESCOMPLETE(_menu), [_menu]] call FUNC(dynamicCall);
		
		// Swap back to our parent
		// Otherwise, the series complete event returns true 
		// if it handled its own exit and navigated to a different menu
		if(isNil "_ret") then { _ret = false; };
		if(!_ret) then {
			_parent = MENU_PARENT(_menu);
			TRACE_1("Calling Parent!", _parent);
			[_parent] call FUNC(changeMenu);
		};
	};
};