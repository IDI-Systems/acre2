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

    class ACRE_SEM70 : ACRE_BaseRadio {
        displayName = "SEM 70";
        useActionTitle = "SEM 70";
        picture = QUOTE(PATHTOF(data\ui\sem70_icon.paa));
        model = QUOTE(PATHTOF(data\model\sem70.p3d));
        descriptionShort = "Sender/Empfänger, mobil SEM 70";

        scopeCurator = 2;
        scope = 2;

        type = 4096;
        simulation = "ItemMineDetector";
        class ItemInfo
        {
            mass = 120;
            allowedSlots[] = {901};
            type = 0;
            scope = 0;
        };

        class Library
        {
            libTextDesc = "SEM 70";
        };
    };

    RADIO_ID_LIST(ACRE_SEM70)
};
