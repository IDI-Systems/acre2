private ["_unit", "_weapons", "_handled"];


_unit = _this select 0;

if ( local _unit ) then
{
	// first remove all weapons in vehicle cargo
	
	clearWeaponCargoGlobal _unit ;
	

	// and now add all given weapons
	_weapons = _this select 1;
	{
		_unit addWeaponCargoGlobal _x
		
	} forEach _weapons;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
