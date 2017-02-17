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

    // replace ItemRadios icon with the 343 icon for stupid people

    class ACRE_PRC343 : ACRE_BaseRadio {
        displayName = "AN/PRC-343";
        useActionTitle = "AN/PRC-343";
        picture = QPATHTOF(Data\static\prc343_icon.paa);
        model = QPATHTOF(Data\models\acre_prc343_model.p3d);
        descriptionShort = "AN/PRC-343 PRR Radio";

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
            libTextDesc = "AN/PRC-343";
        };
    };

    RADIO_ID_LIST(ACRE_PRC343)
};
