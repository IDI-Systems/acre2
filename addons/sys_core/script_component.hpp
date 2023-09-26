#define COMPONENT sys_core
#define COMPONENT_BEAUTIFIED Core
#include "\idi\acre\addons\main\script_mod.hpp"

// #define USE_DEBUG_EXTENSIONS
// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_CORE
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_CORE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_CORE
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"

#define ACRE_REVEAL_AMOUNT 1.6

#define MAX_DIRECT_RANGE 300
#define NEAR_RADIO_RANGE 150

#define ZEUS_INTERFACE_DISPLAY 312
