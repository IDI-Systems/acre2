private ["_unit", "_vest", "_handled"];


_unit = _this select 0;

if ( local _unit ) then
{
	removeVest _unit;

	_vest = _this select 1;

	_unit addVest _vest;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
