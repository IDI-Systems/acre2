private ["_unit", "_primaryStuff", "_secondaryStuff", "_otherStuff", "_handled"];

_unit = _this select 0;
_weapons = _this select 1;
_priKit = _this select 2;
_secKit = _this select 3;


if ( local _unit ) then 
{

	// Remove all weapons on unit
	{
		_unit removeWeapon _x;
	} forEach (weapons _unit);
	// and now add the weapons	
	{
		_unit addWeapon _x;
	} forEach _weapons;
	if ((count _priKit) > 0) then {
		{
			_unit addPrimaryWeaponItem _x;
		} forEach _priKit;
	};	
	
	//Secondary Weapon attachments
	if ((count _secKit) > 0) then {
		{
			_unit addHandgunItem _x;
		} ForEach _secKit;
	};
	
	_handled = true;
} else
{
	_handled = false;
};

_handled // ret
	