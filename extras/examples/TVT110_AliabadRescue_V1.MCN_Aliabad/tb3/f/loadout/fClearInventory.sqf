private ["_unit","_handled"];

_unit = _this select 0;
_uniform = getArray (TB3_GearPath >> _cfg >> _gear >> "uniform");
_vest = getArray (TB3_GearPath >> _cfg >> _gear >> "vest");
_backpack = getArray (TB3_GearPath >> _cfg >> _gear >> "backpack");

if ( local _unit ) then {

	_rM = magazines _unit;
	{_unit removeMagazine _x;} forEach _rM;
	_rAI = assignedItems _unit;
	{_unit unassignItem _x; _unit removeItem _x;} forEach _rAI;
	_rI = items _unit;
	{_unit removeItem _x; } forEach _rI;
	_rW = weapons _unit;
	{_unit removeWeapon _x;} forEach _rW;

	if(_uniform select 0 != uniform _unit) then { removeUniform _unit; };
	if(_backpack select 0 != backpack _unit) then { removeBackPack _unit; };
	if(_vest select 0 != vest _unit) then { removeVest _unit; };
	
	removeGoggles _unit;
	removeHeadGear _unit; //no you may not leave your hat on.
	
	
} else { 

	_handled = false;
	
};

_handled;