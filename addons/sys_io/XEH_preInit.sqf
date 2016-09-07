NO_DEDICATED;
#include "script_component.hpp"

ADDON = false;

LOG(MSG_INIT);

PREP(sendMessage);
PREP(createPacket);
PREP(getPacket);
PREP(restartServer);
PREP(sendPacket);
PREP(serverRunning);
PREP(startServer);
PREP(stopServer);
PREP(serverReadLoop);
PREP(server);
PREP(ping);


DGVAR(pipeCode) = "0";
DGVAR(FIFO) = [];
DGVAR(ioEventFnc) = {};
DGVAR(runserver) = false;
DGVAR(serverStarted) = false;
DGVAR(pongTime) = diag_tickTime;
DGVAR(connectCount) = 15;

ADDON = true;
