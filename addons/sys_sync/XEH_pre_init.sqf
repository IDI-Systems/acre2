#include "script_component.hpp"

ADDON = false;

// Helpers
PREP(runScript);

// perFrame/persistant engine handlers
PREP(perFrame_add);
PREP(perFrame_remove);

PREP(perFrame_onFrame);
PREP(perFrame_onTriggerFrame);
PREP(perFrame_monitorFrameRender);

DGVAR(checkLogic) = "logic" createVehicleLocal [-1000,-1000,0];

PREP(perFrameEngine);

// perFrame/persistant variables
DGVAR(lastFrameRender) = 0;
DGVAR(perFrameHandlerArray) = [];

DGVAR(nextPFHid) = -1;
DGVAR(moanCount) = 0;

#ifdef ACRE_PERFORMANCE_COUNTERS
    DVAR(ACRE_PERFORMANCE_COUNTERS_MAXFRAMETIME) = 0.016;
    DVAR(ACRE_PERFORMANCE_COUNTERS_MAXHANDLETIME) = 0.016;

    ACRE_PERFORMANCE_EXCESSIVE_STEP_TRACKER = [];
    ACRE_PERFORMANCE_EXCESSIVE_STEP_TRACKER = [];

    ACRE_PERFORMANCE_EXCESSIVE_FRAME_TRACKER = [];
    ACRE_PERFORMANCE_FRAME_TRACKER = [];
#endif


DFUNC(bitchAndMoanBadMissionMaker) = {
    private ["_message"];
    GVAR(moanCount) = GVAR(moanCount) + 1;
    _message = "!!!! WARNING ONEACHFRAME POSSIBLY REASSIGNED !!!! IT APPEARS THAT A ADDON OR MISSION HAS POSSIBLY FAILED TO CORRECTLY USE THE BIS STACKED EVENT HANDLER FUNCTIONS FOR ONEACHFRAME!";
    diag_log text _message;
    if(GVAR(moanCount) > 10) then {
        acre_player sideChat _message;
        hint _message;
    };
    true
};

ADDON = true;
