#define COMPONENT sys_sem52sl
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_SEM52SL
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_SEM52SL
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SEM52SL
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define GET_VAR(var1) acre_player getVariable QGVAR(var1)
#define SET_VAR(var1,var2) acre_player setVariable [QGVAR(var1), var2]

#define GET_STATE(id) ([GVAR(currentRadioId), "getState", #id] call EFUNC(sys_data,dataEvent))
#define SET_STATE(id, val) ([GVAR(currentRadioId), "setState", [#id, val]] call EFUNC(sys_data,dataEvent))
#define SET_STATE_CRIT(id, val) ([GVAR(currentRadioId), "setStateCritical", [#id, val]] call EFUNC(sys_data,dataEvent))

#define MAIN_DISPLAY (findDisplay 31532)

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
