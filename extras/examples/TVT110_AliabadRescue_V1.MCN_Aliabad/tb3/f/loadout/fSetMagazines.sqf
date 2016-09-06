private ["_unit", "_magazines", "_handled"];


_unit = _this select 0;
_magazines = _this select 1;

if ( local _unit ) then
{
	// first remove all magazines on the unit
	{
		_unit removeMagazine _x;
	} forEach (magazines _unit);

	// and now add all given magazines
	
	{
		_magazine = _x select 0;
		_amount = _x select 1;
		
		for "_i" from 1 to _amount do
		{
			_unit addMagazine _magazine;
		};
	} forEach _magazines;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
