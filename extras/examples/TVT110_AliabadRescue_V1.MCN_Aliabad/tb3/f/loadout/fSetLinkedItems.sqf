private ["_unit", "_items", "_handled"];


_unit = _this select 0;

if ( local _unit ) then 
{
	// first remove all items
	removeAllAssignedItems _unit;

	// and now add the items
	_items = _this select 1;
	{
		_unit linkItem _x;
	} forEach _items;
	
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
