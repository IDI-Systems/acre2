#define COMPONENT sys_server
#define COMPONENT_BEAUTIFIED Server
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_SERVER
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_SERVER
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SERVER
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define MAX_RADIO 512
