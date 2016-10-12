#define COMPONENT sys_retrans
#define COMPONENT_BEAUTIFIED Retransmission
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_RETRANS
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_RETRANS
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_RETRANS
#endif

#include "\idi\acre\addons\main\script_macros.hpp"
