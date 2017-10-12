class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    // replace ItemRadios icon with the 343 icon for stupid people

    class ACRE_PRC343: ACRE_BaseRadio {
        displayName = "AN/PRC-343";
        useActionTitle = "AN/PRC-343";
        picture = QPATHTOF(Data\static\prc343_icon.paa);
        model = QPATHTOF(Data\models\acre_prc343_model.p3d);
        descriptionShort = "AN/PRC-343 PRR Radio";

        scopeCurator = 2;
        scope = 2;

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 8;
            scope = 0;
        };

        class Library {
            libTextDesc = "AN/PRC-343";
        };
    };

    RADIO_ID_LIST(ACRE_PRC343)
};
