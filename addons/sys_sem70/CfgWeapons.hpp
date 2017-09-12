class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    class ACRE_SEM70: ACRE_BaseRadio {
        displayName = "SEM 70";
        useActionTitle = "SEM 70";
        picture = QPATHTOF(data\ui\sem70_icon.paa);
        model = QPATHTOF(data\model\sem70.p3d);
        descriptionShort = "Sender/Empfänger, mobil SEM 70";

        scopeCurator = 2;
        scope = 2;

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 120;
            allowedSlots[] = {901};
            scope = 0;
        };

        class Library {
            libTextDesc = "SEM 70";
        };
    };

    RADIO_ID_LIST(ACRE_SEM70)
};
