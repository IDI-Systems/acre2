#define COMPONENT SYS_WS38
#define COMPONENT_BEAUTIFIED WS38
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS
// #define DEBUG_ENABLED_SYS_WS38

#ifdef DEBUG_ENABLED_SYS_WS38
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_WS38
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_WS38
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define NAME_WS38 WS No. 38
#define LONG_NAME Wireless Set No. 38 Mk. II

#define GET_VAR(var1) acre_player getVariable QGVAR(var1)
#define SET_VAR(var1,var2) acre_player setVariable [QGVAR(var1), var2]

#define MAIN_DISPLAY (findDisplay 31337)

#define MIN_FREQUENCY 7.4
#define MAX_FREQUENCY 9.0
#define INDEX_CONVERSION (MIN_FREQUENCY * 10)
#define MAX_DIAL_INDICES (MAX_FREQUENCY * 10 - MIN_FREQUENCY * 10)

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
