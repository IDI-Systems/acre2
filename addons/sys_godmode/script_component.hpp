#define COMPONENT sys_godmode
#define COMPONENT_BEAUTIFIED God Mode
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_GODMODE
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_GODMODE
    #define DEBUG_SETTINGS DEBUG_ENABLED_SYS_GODMODE
#endif

#include "\idi\acre\addons\main\script_macros.hpp"


// Group defines
#define GODMODE_CURRENTCHANNEL   0
#define GODMODE_GROUP1           1
#define GODMODE_GROUP2           2
#define GODMODE_GROUP3           3
#define GODMODE_NUMBER_OF_GROUPS 3

// Group operation defines
#define GODMODE_ACTION_SET       0
#define GODMODE_ACTION_ADD       1
#define GODMODE_ACTION_SUBTRACT  2

// Array indices
#define GODMODE_ACCESS_ALLOWED_CHANNEL 0
#define GODMODE_ACCESS_ALLOWED_GROUP   1
