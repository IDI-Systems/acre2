class CfgVehicles {
    class NATO_Box_Base;
    class ACRE_RadioSupplyCrate: NATO_Box_Base {
        scope = 2;
        scopeCurator = 2;
        accuracy = 1000;
        displayName = CSTRING(radioSupplyCrate);
        model = QPATHTOF(data\models\acre_radiobox.p3d);
        editorPreview = QPATHTOF(data\ui\acreRadioBox.jpg);
        author = "RanTa";
        class TransportItems {
            MACRO_ADDITEM(ACRE_PRC77,5);
            MACRO_ADDITEM(ACRE_PRC117F,5);
            MACRO_ADDITEM(ACRE_PRC148,10);
            MACRO_ADDITEM(ACRE_PRC152,10);
            MACRO_ADDITEM(ACRE_PRC343,10);
            MACRO_ADDITEM(ACRE_SEM52SL,10);
            MACRO_ADDITEM(ACRE_SEM70,5);
            MACRO_ADDITEM(ACRE_BF888S,10);
        };
    };

    // Backwards compatibility
    class B_Kitbag_mcamo;
    class ACRE_testBag: B_Kitbag_mcamo {
        scope = 1; // Hidden in 2.5.1
        displayName = "ACRE TEST BAG";
        allowedSlots[] = {701, 801, 901};
    };
};
