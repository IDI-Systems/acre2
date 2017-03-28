#include "script_component.hpp"

if (GVAR(serverStarted) && isMultiplayer) then {
    // Move TeamSpeak 3 channel on display 46 (main display) initialization
    call FUNC(ts3ChannelMove);
};
