#define COMPONENT sys_server
#include "\idi\acre\addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_SERVER
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_SERVER
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SERVER
#endif


#include "\idi\acre\addons\main\script_macros.hpp"

#define DEFAULT_COLLECTION_TIME 350

#define MAX_RADIO 512
