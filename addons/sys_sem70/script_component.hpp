#define COMPONENT sys_sem70
#define COMPONENT_BEAUTIFIED SEM 70
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_SEM70
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_SEM70
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SEM70
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define NAME_SEM70 SEM 70

#define GET_VAR(var1) acre_player getVariable QUOTE(GVAR(var1))
#define SET_VAR(var1,var2) acre_player setVariable [QUOTE(GVAR(var1)), var2]

#define MAIN_DISPLAY (findDisplay 31532)

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
#include "\idi\acre\addons\sys_rack\script_acre_rack_defines.hpp"
