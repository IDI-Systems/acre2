class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    class ACRE_PRC117F: ACRE_BaseRadio {
        displayName = QUOTE(NAME_PRC117F);
        useActionTitle = QUOTE(NAME_PRC117F);
        //model = QPATHTOF(Data\Models\PRC117F.p3d);
        picture = QPATHTOF(Data\PRC117F_ico.paa);
        descriptionShort = "AN/PRC-117F Manpack Radio";
        scopeCurator = 2;
        scope = 2;

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 120;
            allowedSlots[] = {901};
            scope = 0;
         };

        class Library {
            libTextDesc = QUOTE(NAME_PRC117F);
        };
        
        EGVAR(arsenalStats,frequencyMin) = 30e6;
        EGVAR(arsenalStats,frequencyMax) = 512e6;
        EGVAR(arsenalStats,transmitPower) = 20000;
        EGVAR(arsenalStats,effectiveRange) = "20+km (10-20km)";
    };

    RADIO_ID_LIST(ACRE_PRC117F)
};
