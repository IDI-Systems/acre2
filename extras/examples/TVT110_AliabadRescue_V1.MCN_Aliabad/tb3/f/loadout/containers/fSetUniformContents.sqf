private ["_unit", "_uniformContents", "_handled"];

_unit = _this select 0;
_handled = false;


if ( !isNull(uniformContainer _unit) ) then // dealing with a BIS backpack
{
	if ( local _unit ) then 
	{
		_uniformContents = _this select 1;
		
		{
			for "_i" from 1 to (_x select 1) do {
				_unit addItemToUniform (_x select 0);
			};
		} forEach _uniformContents;
		_handled = true;
	};
};

_handled  // ret