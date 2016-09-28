private ["_unit", "_items", "_handled"];


_unit = _this select 0;
_items = _this select 1;

if ( local _unit ) then
{
	// first remove all magazines on the unit
	{
		_unit removeItem _x;
	} forEach (items _unit);

	// and now add all given magazines
	
	{
		_items = _x select 0;
		_amount = _x select 1;
		
		for "_i" from 1 to _amount do
		{
			_unit addItem _items;
		};
	} forEach _items;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret