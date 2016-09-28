private ["_unit", "_backpackARR", "_backpack", "_handled"];


_unit = _this select 0;
_backpackARR = _this select 1;

if ( local _unit ) then
{
	switch (count _backpackARR) do {
		case 1 : {
			removeBackpack _unit;
	
			_backpack = _backpackARR select 0;

			_unit addBackpack _backpack;
				
			_handled = true;
		};
		case 2 : {
			if ((_backpackARR select 1) == 1) then {
				removeBackpack _unit;
		
				_backpack = _backpackARR select 0;

				_unit addBackpack _backpack;
				clearAllItemsFromBackpack _unit;
				
				_handled = true;			
			} else { 
				removeBackpack _unit;
		
				_backpack = _backpackARR select 0;

				_unit addBackpack _backpack;

				_handled = true;
			};
		};
		default {_handled = false;};
	};

} else
{
	_handled = false;
};

_handled // ret
