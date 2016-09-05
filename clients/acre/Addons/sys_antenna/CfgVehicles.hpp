class CfgVehicles {
	class House;

	class ACRE_OE_303: House
	{
		model = QUOTE(PATHTOF(Data\Models\OE303.p3d));
		displayName = "ACRE OE-303 Antenna";
		icon = QUOTE(PATHTOF(Data\Icons\icon_antenna_ca.paa));
		mapSize = 5;
		scope = 2;
		armor = 150;
		vehicleClass = "Military";
	};
};