/*
	This function will take 2 lists, 1 being the ones to prepend, the other being the full list.
	It'll remove duplicates, and prepend the first array. It will also remove radios that don't exist 
	in the second array, from the first array. The return is a [ [1], [2] ] return of the sorted value and the updated prepend list.
*/
#include "script_component.hpp"

params["_prepend", "_currentRadioList"];

private _sortList = [];

private _toRemove = [];
private _sortList = _currentRadioList + [];
{
	if(!(_x in _currentRadioList)) then {
		PUSH(_toRemove, _x);
	} else {
		REM(_sortList, _x);
	};
} forEach _prepend;
{ REM(_prepend, _x); } forEach _toRemove;

private _return = _prepend + _sortList;

[_prepend, _return]