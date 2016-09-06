private ["_unit", "_backpackContents", "_handled"];

_unit = _this select 0;
_handled = false;


if ( !isNull(backpackContainer _unit) ) then // dealing with a BIS backpack
{
	if ( local _unit ) then 
	{
		_backpackContents = _this select 1;
		
		{
			for "_i" from 1 to (_x select 1) do {
				_unit addItemToBackpack (_x select 0);
			};
		} forEach _backpackContents;
		_handled = true;
	};
};

_handled  // ret