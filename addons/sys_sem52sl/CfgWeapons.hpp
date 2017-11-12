class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    class ACRE_SEM52SL: ACRE_BaseRadio {
        displayName = QUOTE(NAME_SEM52SL);
        useActionTitle = QUOTE(NAME_SEM52SL);
        picture = QPATHTOF(data\ui\sem52sl_icon.paa);
        model = QPATHTOF(Data\model\sem52sl.p3d);
        descriptionShort = "Sender/Empfänger, mobil SEM 52 SL";

        scopeCurator = 2;
        scope = 2;

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 8;
            scope = 0;
        };

        class Library {
            libTextDesc = QUOTE(NAME_SEM52SL);
        };
    };

    RADIO_ID_LIST(ACRE_SEM52SL)
};
