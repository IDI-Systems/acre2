#define COMPONENT sys_rack
#define COMPONENT_BEAUTIFIED Rack
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_RACK
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_RACK
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_RACK
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define SET_STATE_RACK(rack, id, val)        ([rack, "setState", [id, val]] call acre_sys_data_fnc_dataEvent)
#define GET_STATE_RACK(rack, id)             ([rack, "getState", id] call acre_sys_data_fnc_dataEvent)

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
