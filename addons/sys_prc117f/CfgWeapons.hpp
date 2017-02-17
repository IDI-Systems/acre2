class CfgWeapons {
    class Default;
    class ACRE_BaseRadio;
    class ItemCore;

    class ACRE_PRC117F : ACRE_BaseRadio {
        displayName = "AN/PRC-117F";
        useActionTitle = "AN/PRC-117F";
        //model = QPATHTOF(Data\Models\PRC117F.p3d);
        picture = QPATHTOF(Data\PRC117F_ico.paa);
        descriptionShort = "AN/PRC-117F Manpack Radio";
        scopeCurator = 2;
        scope = 2;
        class ItemInfo
         {
             mass = 120;
             allowedSlots[] = {901};
            type = 0;
            scope = 0;
         };

        type = 4096;
        simulation = "ItemMineDetector";

        class Library
        {
            libTextDesc = "AN/PRC-117F Manpack Radio";
        };
    };

    RADIO_ID_LIST(ACRE_PRC117F)
};
