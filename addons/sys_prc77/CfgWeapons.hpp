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



    class ACRE_PRC77 : ACRE_BaseRadio {
        displayName = "AN/PRC-77";
        useActionTitle = "AN/PRC-77";
        model = QPATHTOF(Data\models\prc_77.p3d);
        picture = QPATHTOF(Data\prc77_icon.paa);
        descriptionShort = "AN/PRC-77 Manpack Radio";
        scopeCurator = 2;
        scope = 2;

        type = 4096;
        simulation = "ItemMineDetector";

        class ItemInfo {
             mass = 120;
             allowedSlots[] = {901};
            type = 0;
            scope = 0;
         };

        class Library
        {
            libTextDesc = "AN/PRC-77";
        };
    };

    RADIO_ID_LIST(ACRE_PRC77)
};
