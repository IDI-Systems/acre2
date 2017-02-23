#define COMPONENT sys_intercom
#define COMPONENT_BEAUTIFIED Vehicle intercom
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DRAW_INFANTRYPHONE_INFO
// #define DRAW_INTERSECT_INFO
// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_INTERCOM
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_INTERCOM
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_INTERCOM
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define INFANTRYPHONE_MAXDISTANCE_DEFAULT 10 // @todo replace with ace_interaction_fnc_getInteractionDistance when ACE 3.9.1 releases
#define INFANTRYPHONE_MAXDISTANCE_HULL 1.5
