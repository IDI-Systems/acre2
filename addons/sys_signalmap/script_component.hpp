#define COMPONENT sys_signalmap
#include "\idi\acre\addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_SIGNALMAP
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_SIGNALMAP
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SIGNALMAP
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
#define CTRL(var, type)    var = GVAR(mapDisplay) ctrlCreate [type, GVAR(debugIdc), GVAR(ctrlGroup)]; GVAR(debugIdc) = GVAR(debugIdc) + 1; GVAR(signal_debug) pushBack var
#define CTRLOVERLAY(var, type)    var = GVAR(mapDisplay) ctrlCreate [type, GVAR(debugIdc), GVAR(overlayMessageGrp)]; GVAR(debugIdc) = GVAR(debugIdc) + 1; GVAR(signal_debug) pushBack var
