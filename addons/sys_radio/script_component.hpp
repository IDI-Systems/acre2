#define COMPONENT sys_radio

#include "\idi\acre\addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_RADIO
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_RADIO
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_RADIO
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define RADIO(radioName,radioId) PREFIX_ItemRadio_#radioName_#radioId


#define GET_UI_VAR(var1) uiNameSpace getVariable QUOTE(var1)
#define SET_UI_VAR(var1,var2) uiNamespace setVariable [QUOTE(var1), var2]
