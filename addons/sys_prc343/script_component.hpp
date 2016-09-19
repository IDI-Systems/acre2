#define COMPONENT sys_prc343

#include "\idi\acre\addons\main\script_mod.hpp"

//#define DEBUG_ENABLED_SYS_PRC343
#ifdef DEBUG_ENABLED_SYS_PRC343
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_PRC343
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_PRC343
#endif


#include "\idi\acre\addons\main\script_macros.hpp"

#define GET_VAR(var1) acre_player getVariable QUOTE(GVAR(var1))
#define SET_VAR(var1,var2) acre_player setVariable [QUOTE(GVAR(var1)), var2]

#define MAIN_DISPLAY    (findDisplay 31337)

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
