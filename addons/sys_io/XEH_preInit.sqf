#include "script_component.hpp"

ADDON = false;

LOG(MSG_INIT);

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(initialized) = false;  // "init" called on the voice extension
GVAR(connected) = false;    // connected to the voice server
GVAR(connecting) = false;
GVAR(peerId) = -1;
GVAR(lastTokenRequest) = -1e10;
GVAR(hasConnectedBefore) = false;
GVAR(lastConnectError) = "";
GVAR(missionEnded) = false;

// Results and events from the voice extension (both clients and the server use it).
addMissionEventHandler ["ExtensionCallback", {
    params ["_name", "_function", "_data"];
    if (_name == EXTENSION_NAME) then {
        [_function, _data] call FUNC(handleCallback);
    };
}];

if (hasInterface) then {
    // The server's answer to a token request.
    [QGVAR(voiceToken), FUNC(handleToken)] call CBA_fnc_addEventHandler;
};

ADDON = true;
