class CfgWeapons {
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;

    class ACRE_VHF30108: CBA_MiscItem {
        author[] = {"RanTa"};
        scope = 2;
        displayName = "VHF30108 GSM";
        descriptionShort = CSTRING(gsaWithMast_description);
        model = QPATHTOF(data\models\acre_antennaBag.p3d);
        picture = QPATHTOF(data\ui\acre_antennabag_icon.paa);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 160;
        };
    };
    class ACRE_VHF30108SPIKE: ACRE_VHF30108 {
        displayName = "VHF30108 GS";
        descriptionShort = CSTRING(gsaWithoutMast_description);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 60;
        };
    };

    class ACRE_VHF30108MAST: ACRE_VHF30108 {
        displayName = "VHF30108 Mast";
        descriptionShort = "VHF30108 Mast";

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 100;
        };
    };
};
