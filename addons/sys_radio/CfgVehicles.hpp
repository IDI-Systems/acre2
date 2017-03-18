#define NUM_RADIOS_IN_CRATE 50

class CfgVehicles {
    class NATO_Box_Base;
    class ACRE_radioSupplyCrate: NATO_Box_Base {
        scope = 2;
        scopeCurator = 2;
        accuracy = 1000;
        model = "\A3\weapons_F\AmmoBoxes\AmmoBox_F";
        author = "ACRE2-Team";
        class TransportItems {
            MACRO_ADDITEM(ACRE_PRC77,NUM_RADIOS_IN_CRATE);
            MACRO_ADDITEM(ACRE_PRC117F,NUM_RADIOS_IN_CRATE);
            MACRO_ADDITEM(ACRE_PRC148,NUM_RADIOS_IN_CRATE);
            MACRO_ADDITEM(ACRE_PRC152,NUM_RADIOS_IN_CRATE);
            MACRO_ADDITEM(ACRE_PRC343,NUM_RADIOS_IN_CRATE);
            MACRO_ADDITEM(ACRE_SEM52SL,NUM_RADIOS_IN_CRATE);
            MACRO_ADDITEM(ACRE_SEM70,NUM_RADIOS_IN_CRATE);
        };
    };
};
