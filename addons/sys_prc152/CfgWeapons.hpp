class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    class ACRE_PRC152: ACRE_BaseRadio {
        displayName = QUOTE(NAME_PRC152);
        useActionTitle = QUOTE(NAME_PRC152);
        model = QPATHTOF(Data\Models\PRC152.p3d);
        picture = QPATHTOF(Data\PRC152c_ico.paa);
        descriptionShort = "AN/PRC-152 VHF/UHF Radio";
        scopeCurator = 2;
        scope = 2;

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 8;
            scope = 0;
        };

        class Library {
            libTextDesc = QUOTE(NAME_PRC152);
        };
    };

    RADIO_ID_LIST(ACRE_PRC152)
};
