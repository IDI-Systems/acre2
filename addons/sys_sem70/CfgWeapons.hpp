class CfgWeapons {
    class ACRE_BaseRadio;
    class CBA_MiscItem_ItemInfo;

    class ACRE_SEM70: ACRE_BaseRadio {
        displayName = QUOTE(NAME_SEM70);
        useActionTitle = QUOTE(NAME_SEM70);
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
            libTextDesc = QUOTE(NAME_SEM70);
        };

        EGVAR(arsenalStats,frequencyMin) = 46e3;
        EGVAR(arsenalStats,frequencyMax) = 65.975e6;
        EGVAR(arsenalStats,transmitPower) = 4000;
        EGVAR(arsenalStats,effectiveRange) = "3-5km (1-3km)"; // not sure?
        EGVAR(arsenalStats,externalSpeaker) = 1;
    };

    RADIO_ID_LIST(ACRE_SEM70)
};
