#include "script_component.hpp"

["sideReady", [(side player)]] call CBA_fnc_globalEvent;
GVAR(start_board) removeAction (player getVariable[QGVAR(readyActionId), -1]);