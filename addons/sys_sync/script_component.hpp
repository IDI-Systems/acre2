#define COMPONENT sys_sync

#include "\idi\acre\addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_SYNC
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_SYNC
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SYNC
#endif

#define ACRE_SYNC(x) "as_"+##x

#include "\idi\acre\addons\main\script_macros.hpp"
