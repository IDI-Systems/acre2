private ["_unit", "_items", "_handled"];


_unit = _this select 0;

if ( local _unit ) then
{
	// first remove all magazines in vehicle cargo
	
	clearItemCargoGlobal _unit ;
	

	// and now add all given magazines
	_items = _this select 1;
	{
		_unit addItemCargoGlobal _x
		
	} forEach _items;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
