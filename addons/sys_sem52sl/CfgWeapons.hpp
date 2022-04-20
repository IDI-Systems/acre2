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

        EGVAR(arsenalStats,frequencyMin) = 46e3;
        EGVAR(arsenalStats,frequencyMax) = 65.975e6;
        EGVAR(arsenalStats,transmitPower) = 1000;
        EGVAR(arsenalStats,effectiveRange) = "2-4km (1-2km)"; // not sure?
        EGVAR(arsenalStats,externalSpeaker) = 1;
    };

    RADIO_ID_LIST(ACRE_SEM52SL)
};
