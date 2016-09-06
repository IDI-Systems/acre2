#include "script_component.hpp"
/*
DFUNC(perFrame_Dialog) = {
    //waitUntil {time > 0}; // OK
    //6323 cutRsc ["ACRE_FrameHandlerTitle", "PLAIN"];


};

DFUNC(perFrame_Trigger) = {
    GVAR(perFrameTrigger) = createTrigger["EmptyDetector", [0,0,0], false];
    GVAR(perFrameTrigger) setTriggerActivation["ANY","PRESENT",true];
    GVAR(perFrameTrigger) setTriggerStatements[QUOTE(call FUNC(perFrame_onTriggerFrame)), "", ""];
};
*/
DFUNC(perFrame_TriggerClient) = {
    GVAR(perFrameTrigger) = createTrigger["EmptyDetector", [0,0,0], false];
    GVAR(perFrameTrigger) setTriggerActivation["ANY","PRESENT",true];
    GVAR(perFrameTrigger) setTriggerStatements[QUOTE(call FUNC(perFrame_monitorFrameRender)), "", ""];
    [] spawn {
        private _currentTickTime = diag_tickTime-2;
        waitUntil {
            [] call FUNC(perFrame_monitorFrameRender);
            if(diag_tickTime - _currentTickTime >= 1.5) then {
                _currentTickTime = diag_tickTime;
                // acre_player sideChat "setting override";
                ["setSoundSystemMasterOverride", [1]] call EFUNC(sys_rpc,callRemoteProcedure);
            };
            time > 0;
        };
        if(isMultiplayer) then {
            ["setSoundSystemMasterOverride", [0]] call EFUNC(sys_rpc,callRemoteProcedure);
        };
    };
};

#ifdef PLATFORM_A3
[QUOTE(acreBISPFH), "oneachframe", FUNC(perFrame_onFrame)] call BIS_fnc_addStackedEventHandler;
#endif
#ifdef PLATFORM_A2
[FUNC(perFrame_onFrame), 0, []] call cba_fnc_addPerFrameHandler;
#endif
[] call FUNC(perFrame_TriggerClient);
