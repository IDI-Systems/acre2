private ["_unit", "_headgear", "_handled"];


_unit = _this select 0;

if ( local _unit ) then
{
	removeHeadgear _unit;
	
	_headgear = _this select 1;

	_unit addHeadgear _headgear;
		
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
