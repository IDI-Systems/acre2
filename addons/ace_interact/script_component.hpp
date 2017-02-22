#define COMPONENT ace_interact
#define COMPONENT_BEAUTIFIED ACE3 Interaction
#include "\idi\acre\addons\main\script_mod.hpp"

#define DRAW_INFANTRYPHONE_INFO
//#define DRAW_INTERSECT_INFO
#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_ACE_INTERACT
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_ACE_INTERACT
    #define DEBUG_SETTINGS DEBUG_SETTINGS_ACE_INTERACT
#endif

#include "\idi\acre\addons\main\script_macros.hpp"


#define INFANTRYPHONE_MAXDISTANCE_DEFAULT 10 // @todo replace with ace_interaction_fnc_getInteractionDistance when ACE 3.9.1 releases
#define INFANTRYPHONE_MAXDISTANCE_CUSTOM 1.5
