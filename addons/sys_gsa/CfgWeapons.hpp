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

    class ACRE_12FT_ANTENNA: CBA_MiscItem {
        author[] = {"S. Spartan"};
        scope = 2;
        displayName = "WS38 12FT Antenna";
        descriptionShort = CSTRING(WS3812ftAntenna_description);
        model = QPATHTOEF(sys_ws38,data\Models\ws38_aerial_bag.p3d);
        picture = QPATHTOF(data\ws38_antenna\ui\icon_bag.paa);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 30;
        };
    };
};
