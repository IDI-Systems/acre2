class CfgVehicles {
    class Man;
    class CAManBase: Man {
        acre_antennaMemoryPoints[] = {{"LeftShoulder", "LeftShoulder"}};
        //acre_antennaMemoryPointsDir[] = {{"Spine3", "Neck"}};
        acre_antennaDirFnc = QFUNC(getAntennaDirMan);
    };
    class Thing;
    class ACRE_BaseRack : Thing {
        author = ECSTRING(main,Author);
        displayName = "ACRE Base Rack";
        scope = 0;
        mass = 0;
        vehicleClass = "";

        acre_isRack = 1;
        acre_hasUnique = 1;
    };

};
