class Extended_PreInit_EventHandlers {
    class ADDON    {
        init = QUOTE(call COMPILE_FILE(XEH_pre_init));
    };
};
class Extended_PostInit_EventHandlers {
    class ADDON    {
        init = QUOTE(call COMPILE_FILE(XEH_post_init));
    };
};
class Extended_GetIn_EventHandlers {
    class Car {
        GVAR(getIn) = QUOTE(call COMPILE_FILE(fnc_onGetInVehicle));
    };
    class Tank {
        GVAR(getIn) = QUOTE(call COMPILE_FILE(fnc_onGetInVehicle));
    };
    class Static {
        GVAR(getIn) = QUOTE(call COMPILE_FILE(fnc_onGetInVehicle));
    };
    class Air {
        GVAR(getIn) = QUOTE(call COMPILE_FILE(fnc_onGetInVehicle));
    };
};
class Extended_GetOut_EventHandlers {
    class Car {
        GVAR(getOut) = QUOTE(call COMPILE_FILE(fnc_onGetOutVehicle));
    };
    class Tank {
        GVAR(getOut) = QUOTE(call COMPILE_FILE(fnc_onGetOutVehicle));
    };
    class Static {
        GVAR(getOut) = QUOTE(call COMPILE_FILE(fnc_onGetOutVehicle));
    };
    class Air {
        GVAR(getOut) = QUOTE(call COMPILE_FILE(fnc_onGetOutVehicle));
    };
};
class Extended_Killed_EventHandlers {
    class Man {
        ADDON = QUOTE(_this call FUNC(onPlayerKilled));
    };
};
