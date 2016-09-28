#include "script_component.hpp"

["missionStart", FUNC(onMissionStart)] call CBA_fnc_addEventHandler;
["missionEnd", FUNC(onMissionEnd)] call CBA_fnc_addEventHandler;
["sideReady", FUNC(onSideReady)] call CBA_fnc_addEventHandler;
["teleportGroup", FUNC(onTeleportGroup)] call CBA_fnc_addEventHandler;
