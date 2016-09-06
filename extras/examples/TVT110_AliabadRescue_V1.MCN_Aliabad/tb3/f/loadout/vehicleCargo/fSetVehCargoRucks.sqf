private ["_unit", "_rucks", "_handled"];


_unit = _this select 0;

if ( local _unit ) then
{
	// first remove all magazines in vehicle cargo
	
	clearBackpackCargoGlobal _unit ;
	

	// and now add all given magazines
	_rucks = _this select 1;
	{
		_unit addBackpackCargoGlobal _x
		
	} forEach _rucks;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret