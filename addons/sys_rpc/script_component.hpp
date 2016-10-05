#define COMPONENT sys_rpc
#define COMPONENT_BEAUTIFIED Remote Procedures
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_RPC
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_RPC
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_RPC
#endif

#include "\idi\acre\addons\main\script_macros.hpp"
