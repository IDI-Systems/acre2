class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    // replace ItemRadios icon with the 343 icon for stupid people

    class ACRE_WS38: ACRE_BaseRadio {
        displayName = QUOTE(NAME_WS38);
        useActionTitle = QUOTE(NAME_WS38);
        picture = QPATHTOF(Data\static\ws38_icons.paa);
        model = QPATHTOF(Data\models\ws38_radio.p3d);
        descriptionShort = "Wireless Set No. 38 Mk. II Radio";

        scopeCurator = 2;
        scope = 2;

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 30;
            scope = 0;
        };

        class Library {
            libTextDesc = QUOTE(NAME_WS38);
        };

        EGVAR(arsenalStats,frequencyMin) = 7.4e6;
        EGVAR(arsenalStats,frequencyMax) = 9e6;
        EGVAR(arsenalStats,transmitPower) = 200;
        EGVAR(arsenalStats,effectiveRange) = "800m (400m)";
    };

    RADIO_ID_LIST(ACRE_WS38)
};
