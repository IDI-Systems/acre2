private ["_unit", "_vestContents", "_handled"];

_unit = _this select 0;
_handled = false;


if ( !isNull(vestContainer _unit) ) then // dealing with a BIS backpack
{
	if ( local _unit ) then 
	{
		_vestContents = _this select 1;
		
		{
			for "_i" from 1 to (_x select 1) do {
				_unit addItemToVest (_x select 0);
			};
		} forEach _vestContents;
		_handled = true;
	};
};
