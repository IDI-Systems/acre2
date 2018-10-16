#define COMPONENT sys_prc77
#define COMPONENT_BEAUTIFIED AN/PRC-77
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_PRC77
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_PRC77
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_PRC77
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define NAME_PRC77 AN/PRC-77

#define GET_VAR(var1) acre_player getVariable QGVAR(var1)
#define SET_VAR(var1,var2) acre_player setVariable [QGVAR(var1), var2]

#define MAIN_DISPLAY (findDisplay 31337)

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
#include "\idi\acre\addons\sys_rack\script_acre_rack_defines.hpp"
