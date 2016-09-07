#include "script_component.hpp"

#define PREP(fncName) FUNC(fncName) = compile preprocessFileLineNumbers QUOTE(DOUBLES(fnc,fncName).sqf);

PREP(jip);

PREP(radioPresets);

PREP(randomizeCrashStart);
PREP(initializeStartTimer);

PREP(monitorStartAreas);
PREP(monitorEndCondition);

PREP(doReady);
PREP(doSelectTeamStart);

PREP(onSideReady);
PREP(onMissionEnd);
PREP(onMissionStart);
PREP(onTeleportGroup);

GVAR(started) = false;
GVAR(sideReady) = [];

GVAR(serverPFH) = -1;
GVAR(killTrack) = [0,0,0];

GVAR(bluforStartCount) = 0;
GVAR(opforStartCount) = 0;
GVAR(civilianStartCount) = 0;