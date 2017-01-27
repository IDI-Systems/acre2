/*
 * Author: ACRE2Team
 * Informs, once all checks are passed, that all ACRE2 core components are properly loaded. It is executed
 * as a per frame handler until all core checks are successful.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_coreInitPFH
 *
 * Public: No
 */
#include "script_component.hpp"

if (isNull player) exitWith { };
acre_player = player;

if (!ACRE_MAP_LOADED) exitWith { };
if (!ACRE_DATA_SYNCED) exitWith { };
if (GVAR(ts3id) == -1) exitWith { };

TRACE_1("GOT TS3 ID", GVAR(ts3id));

[] call FUNC(utilityFunction); // OK
[] call FUNC(muting);
[] call FUNC(speaking);

//Set the speaking volume to normal.
[.7] call acre_api_fnc_setSelectableVoiceCurve;
acre_sys_gui_VolumeControl_Level = 0;

ACRE_CORE_INIT = true;
TRACE_1("ACRE CORE INIT", ACRE_CORE_INIT);
[(_this select 1)] call CBA_fnc_removePerFrameHandler;
