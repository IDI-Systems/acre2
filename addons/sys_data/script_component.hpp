#define COMPONENT sys_data
#define COMPONENT_BEAUTIFIED Data
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_DATA
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_DATA
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_DATA
#endif

#define IS_SERIALIZEDHASH(array) (IS_ARRAY(array) && {array isNotEqualTo []} && {(array select 0) isEqualTo "ACRE_HASH"})

#include "\idi\acre\addons\main\script_macros.hpp"
