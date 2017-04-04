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
    class ADDON {
        clientInit = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

class Extended_InitPost_EventHandlers {
    class LandVehicle {
        class ADDON {
            init = QUOTE(_this call DFUNC(initActionVehicle));
        };
    };
    class Air {
        class ADDON {
            init = QUOTE(_this call DFUNC(initActionVehicle));
        };
    };
    class Ship_F {
        class ADDON {
            init = QUOTE(_this call DFUNC(initActionVehicle));
        };
    };
};
