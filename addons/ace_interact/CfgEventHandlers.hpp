class Extended_PreInit_EventHandlers {
    class ADDON    {
        init = QUOTE(call COMPILE_FILE(XEH_pre_init));
    };
};


class Extended_InitPost_EventHandlers {
    class LandVehicle {
        class ADDON {
            init = QUOTE(_this call DFUNC(initVehicle));
        };
    };
    class Air {
        class ADDON {
            init = QUOTE(_this call DFUNC(initVehicle));
        };
    };
    class Ship_F {
        class ADDON {
            init = QUOTE(_this call DFUNC(initVehicle));
        };
    };
};