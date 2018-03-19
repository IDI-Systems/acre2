class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON    {
        clientInit = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

// Begin inventory extensions
class Extended_InventoryOpened_EventHandlers {
    class CAManBase {
        class ADDON {
            clientInventoryOpened = QUOTE(_this call FUNC(openInventory));
        };
    };
};

class Extended_DisplayLoad_EventHandlers {
    class RscDisplayMission {
        ADDON = QUOTE(_this call FUNC(missionDisplayLoad));
    };
};
