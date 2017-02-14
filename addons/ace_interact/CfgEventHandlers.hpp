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

class Extended_InitPost_EventHandlers {
    class LandVehicle {
        class ADDON {
            init = QUOTE(_this call DFUNC(externalRadioVehicleListChildrenActions));
        };
    };
    class Air {
        class ADDON {
            init = QUOTE(_this call DFUNC(externalRadioVehicleListChildrenActions));
        };
    };
    class Ship_F {
        class ADDON {
            init = QUOTE(_this call DFUNC(externalRadioVehicleListChildrenActions));
        };
    };
};
