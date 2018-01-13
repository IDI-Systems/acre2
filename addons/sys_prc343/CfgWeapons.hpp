class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    // replace ItemRadios icon with the 343 icon for stupid people

    class ACRE_PRC343: ACRE_BaseRadio {
        displayName = QUOTE(NAME_PRC343);
        useActionTitle = QUOTE(NAME_PRC343);
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
            libTextDesc = QUOTE(NAME_PRC343);
        };
    };

    RADIO_ID_LIST(ACRE_PRC343)
};
