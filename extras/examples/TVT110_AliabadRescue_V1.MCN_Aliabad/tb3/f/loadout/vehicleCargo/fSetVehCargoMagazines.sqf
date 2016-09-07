private ["_unit", "_magazines", "_handled"];


_unit = _this select 0;

if ( local _unit ) then
{
	// first remove all magazines in vehicle cargo
	
	clearMagazineCargoGlobal _unit ;
	

	// and now add all given magazines
	_magazines = _this select 1;
	{
		_unit addMagazineCargoGlobal _x
		
	} forEach _magazines;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
