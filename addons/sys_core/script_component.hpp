#define COMPONENT sys_core
#include "\idi\acre\addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_CORE
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_CORE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_CORE
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define EOL_CHAR toString[10]

//#define USE_DEBUG_EXTENSIONS
