class CfgWeapons {

    class ACRE_GameComponentBase;

    class ItemRadio;
    class ItemRadioAcreFlagged: ItemRadio {
        scopeCurator = 1;
        scope = 1;
        class ItemInfo {
            mass = 0;
        };
    };

    class ACRE_BaseComponent: ACRE_GameComponentBase {
        acre_hasUnique = 1;
        scopeCurator = 1;
        scope = 1;
    };

    class ACRE_BaseRadio: ACRE_BaseComponent {
        displayName = "ACRE Radio";
        useActionTitle = "ACRE: Pickup Radio";
        acre_isRadio = 1;

        class Library {
            libTextDesc = "ACRE Radio";
        };
    };

};
