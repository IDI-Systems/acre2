#define COMPONENT api
#define COMPONENT_BEAUTIFIED API
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_ENABLED_API
// #define RECOMPILE

#ifdef DEBUG_ENABLED_API
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_API
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_API
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
#include "\idi\acre\addons\sys_godmode\script_acre_component_defines.hpp"
