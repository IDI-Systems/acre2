class CfgWeapons {
    class Default;
    class ACRE_BaseRadio;
    class ItemCore;

    class ACRE_PRC152 : ACRE_BaseRadio {
        displayName = "AN/PRC-152";
        useActionTitle = "AN/PRC-152";
        model = QPATHTOF(Data\Models\PRC152.p3d);
        picture = QPATHTOF(Data\PRC152c_ico.paa);
        descriptionShort = "AN/PRC-152 VHF/UHF Radio";
        scopeCurator = 2;
        scope = 2;

        type = 4096;
        simulation = "ItemMineDetector";
        class ItemInfo
        {
            mass = 8;
            type = 0;
            scope = 0;
        };

        class Library
        {
            libTextDesc = "AN/PRC-152 VHF/UHF Radio";
        };
    };

    RADIO_ID_LIST(ACRE_PRC152)
};
