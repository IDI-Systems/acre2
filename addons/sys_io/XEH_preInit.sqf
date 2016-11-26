NO_DEDICATED;
#include "script_component.hpp"

ADDON = false;

LOG(MSG_INIT);

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

DGVAR(pipeCode) = "0";
DGVAR(ioEventFnc) = {};
DGVAR(runserver) = false;
DGVAR(serverStarted) = false;
DGVAR(pongTime) = diag_tickTime;
DGVAR(connectCount) = 15;

ADDON = true;
