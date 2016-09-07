//loadout items
private ["_unit","_cfg","_gear","_items","_assignedItems","_weapons","_magazines","_backpack","_headgear","_uniform","_vest","_goggles","_priKit","_secKit","_backpackContents","_vestContents","_uniformContents","_vehCargoWeapons","_vehCargoMagazines","_vehCargoItems","_vehCargoRucks"];

//core info
_unit = _this select 0;
_cfg = _this select 1;
_gear  = _this select 2;

//get the defined gear.
TB3_GearPath = (missionConfigFile >> "TB3_Gear");
_weapons 			= getArray (TB3_GearPath >> _cfg >> _gear >> "weapons");
_magazines 			= getArray (TB3_GearPath >> _cfg >> _gear >> "magazines");

_priKit				= getArray (TB3_GearPath >> _cfg >> _gear >> "priKit");
_secKit 			= getArray (TB3_GearPath >> _cfg >> _gear >> "secKit");	

_backpack			= getArray (TB3_GearPath >> _cfg >> _gear >> "backpack");
_backpackContents 	= getArray (TB3_GearPath >> _cfg >> _gear >> "backpackContents");
_headgear			= getArray (TB3_GearPath >> _cfg >> _gear >> "headgear");
_uniform			= getArray (TB3_GearPath >> _cfg >> _gear >> "uniform");
_uniformContents 	= getArray (TB3_GearPath >> _cfg >> _gear >> "uniformContents");
_vest				= getArray (TB3_GearPath >> _cfg >> _gear >> "vest");
_vestContents 		= getArray (TB3_GearPath >> _cfg >> _gear >> "vestContents");
_goggles			= getArray (TB3_GearPath >> _cfg >> _gear >> "goggles");
_items				= getArray (TB3_GearPath >> _cfg >> _gear >> "items");
_assignedItems		= getArray (TB3_GearPath >> _cfg >> _gear >> "assignedItems");

_vehCargoWeapons 	= getArray (TB3_GearPath >> _cfg >> _gear >> "vehCargoWeapons");
_vehCargoMagazines 	= getArray (TB3_GearPath >> _cfg >> _gear >> "vehCargoMagazines");
_vehCargoItems 		= getArray (TB3_GearPath >> _cfg >> _gear >> "vehCargoItems");
_vehCargoRucks 		= getArray (TB3_GearPath >> _cfg >> _gear >> "vehCargoRucks");

//Remove the unit's current gear if they are a person and not a vehicle, because fuck vehicles. Those fucking cunts, objects too!
if (_unit isKindOf "Man") then {
	
	if ( local _unit ) then {
		removeAllAssignedItems _unit; 
		removeAllItemsWithMagazines _unit;
		{_unit removeWeapon _x;} forEach weapons _unit;

		if ((count _uniform) > 0) then {	
			if(_uniform select 0 != uniform _unit) then {
				[_unit,_uniform select 0] call tb3_fSetUniform;
			};
		} else {
			removeUniform _unit;
		};
		if ((count _backpack) > 0) then {
			if(_backpack select 0 != backpack _unit) then { 
				[_unit,_backpack] call tb3_fSetBackpack; 
			};
		} else {
			removeBackPack _unit;
		};
		if ((count _vest) > 0) then {
			if(_vest select 0 != vest _unit) then { 
				[_unit,_vest select 0] call tb3_fSetVest; 
			};
		} else {
			removeVest _unit;
		};
		removeGoggles _unit;
		removeHeadGear _unit; //no you may not leave your hat on.
	};
};

if ((count _assignedItems) > 0) then { [_unit,_assignedItems] call tb3_fSetLinkedItems; };
if ((count _headgear) > 0) then { [_unit,_headgear select 0] call tb3_fSetHeadgear;	};		

if ((count _goggles) > 0) then { [_unit,_goggles select 0] call tb3_fSetGoggles; };		
if ((count _magazines) > 0) then {	[_unit,_magazines] call tb3_fSetMagazines; };
if ((count _weapons) > 0) then { [_unit,_weapons,_priKit,_secKit] call tb3_fSetWeapons; };	
if ((count _items) > 0) then { [_unit,_items] call tb3_fSetItems;	};	

if ((count _backpackContents) > 0) then { [_unit,_backpackContents] call tb3_fsetRuckContents; };
if ((count _uniformContents) > 0) then { [_unit,_uniformContents] call tb3_fsetUniformContents; };
if ((count _vestContents) > 0) then { [_unit,_vestContents] call tb3_fsetVestContents; };

if ((count _vehCargoItems) > 0) then { [_unit,_vehCargoItems] call tb3_fSetVehCargoItems; };
if ((count _vehCargoWeapons) > 0) then { [_unit,_vehCargoWeapons] call tb3_fSetVehCargoWeapons; };
if ((count _vehCargoMagazines) > 0) then { [_unit,_vehCargoMagazines] call tb3_fSetVehCargoMagazines; };
if ((count _vehCargoRucks) > 0) then { [_unit,_vehCargoRucks] call tb3_fSetVehCargoBackpacks; };
	
_unit setVariable ["tb3_loadout", _this, true];
_handled = true;