class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    class ACRE_BF888S: ACRE_BaseRadio {
        displayName = QUOTE(NAME_BF888S);
        useActionTitle = QUOTE(NAME_BF888S);
        picture = QPATHTOF(Data\static\bf888s_icon.paa);
        model = QPATHTOF(Data\models\acre_bf888s_model.p3d);
        descriptionShort = "Beofeng BF-888S UHF Radio";

        scopeCurator = 2;
        scope = 2;

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 8;
            scope = 0;
        };

        class Library {
            libTextDesc = QUOTE(NAME_BF888S);
        };
    };

    RADIO_ID_LIST(ACRE_BF888S)
};
