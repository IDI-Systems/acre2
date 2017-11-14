class CfgWeapons {
    // Hide vanilla radio
    class ItemCore;
    class ItemRadio: ItemCore {
        scopeCurator = 1;
        scope = 1;
    };

    // Base class for any ACRE component (using CBA_MiscItem for Virtual Arsenal compatibility)
    class CBA_MiscItem;
    class ACRE_GameComponentBase: CBA_MiscItem {
        author = CSTRING(Author);
        scopeCurator = 1;
        scope = 1;
    };
};
