class Extended_PreInit_EventHandlers {
    class ADDON    {
        init = QUOTE(call COMPILE_FILE(XEH_pre_init));
    };
};
class Extended_PostInit_EventHandlers {
    class ADDON    {
        clientInit = QUOTE(call COMPILE_FILE(XEH_post_init));
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
        ADDON = QUOTE(_this call COMPILE_FILE(XEH_missionDisplayLoad));
    };
};
