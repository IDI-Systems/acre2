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

        EGVAR(arsenalStats,frequencyMin) = 400;
        EGVAR(arsenalStats,frequencyMax) = 470;
        EGVAR(arsenalStats,transmitPower) = 5000;
        EGVAR(arsenalStats,effectiveRange) = "3-5km (2-3km)";
    };

    RADIO_ID_LIST(ACRE_BF888S)
};
