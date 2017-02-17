#define WeaponNoSlot        0    // dummy weapon
#define WeaponSlotPrimary    1    // primary weapon
#define WeaponSlotHandGun    2    // handGun/sidearm
#define WeaponSlotSecondary    4    // secondary weapon    // 4 in ArmA, not 16.
#define WeaponSlotHandGunItem    16    // sidearm/GL magazines    // 16 in ArmA, not 32.
#define WeaponSlotItem        256    // main magazines, items, explosives
#define WeaponSlotBinocular    4096    // binocular, NVG, LD, equipment
#define WeaponHardMounted    65536
#define WeaponSlotSmallItems    131072

class CfgWeapons {
    class Default;
    class ACRE_BaseRadio;
    class ItemCore;

    class ACRE_SEM52SL : ACRE_BaseRadio {
        displayName = "SEM 52 SL";
        useActionTitle = "SEM 52 SL";
        picture = QPATHTOF(data\ui\sem52sl_icon.paa);
        model = QPATHTOF(Data\model\sem52sl.p3d);
        descriptionShort = "Sender/Empfänger, mobil SEM 52 SL";

        scopeCurator = 2;
        scope = 2;

        type = 4096;
        simulation = "ItemMineDetector";
        class ItemInfo
        {
            mass = 8;
            type = 0;
            scope = 0;
        };

        class Library
        {
            libTextDesc = "SEM 52 SL";
        };
    };

    RADIO_ID_LIST(ACRE_SEM52SL)
};
