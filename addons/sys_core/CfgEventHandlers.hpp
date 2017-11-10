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
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

class Extended_Killed_EventHandlers {
    class Man {
        ADDON = QUOTE(_this call FUNC(onPlayerKilled));
    };
};

class Extended_DisplayLoad_EventHandlers {
    class RscDisplayArsenal {
        ADDON = QUOTE(GVAR(arsenalOpen) = true);
    };
    class RscDisplayEGSpectator {
        ADDON = QUOTE(_this call COMPILE_FILE(XEH_spectatorEGDisplayLoad));
    };
};

class Extended_DisplayUnload_EventHandlers {
    class RscDisplayArsenal {
        ADDON = QUOTE(GVAR(arsenalOpen) = false);
    };
    class RscDisplayEGSpectator {
        ADDON = QUOTE(_this call COMPILE_FILE(XEH_spectatorEGDisplayUnload));
    };
};
