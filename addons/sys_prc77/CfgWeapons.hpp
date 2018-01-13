class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    class ACRE_PRC77: ACRE_BaseRadio {
        displayName = QUOTE(NAME_PRC77);
        useActionTitle = QUOTE(NAME_PRC77);
        model = QPATHTOF(Data\models\prc_77.p3d);
        picture = QPATHTOF(Data\prc77_icon.paa);
        descriptionShort = "AN/PRC-77 Manpack Radio";
        scopeCurator = 2;
        scope = 2;

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 120;
            allowedSlots[] = {901};
            scope = 0;
         };

        class Library {
            libTextDesc = QUOTE(NAME_PRC77);
        };
    };

    RADIO_ID_LIST(ACRE_PRC77)
};
