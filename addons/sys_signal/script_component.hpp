#define COMPONENT sys_signal
#define COMPONENT_BEAUTIFIED Signal
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_SIGNAL
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_SIGNAL
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SIGNAL
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define SIGNAL_MODEL_CASUAL        0
#define SIGNAL_MODEL_LOS_SIMPLE    1
#define SIGNAL_MODEL_LOS_MULTIPATH 2
#define SIGNAL_MODEL_ITM           3
#define SIGNAL_MODEL_ITWOM         4  // This model is for now disabled.

#define SIGNAL_ENUMS SIGNAL_MODEL_CASUAL, SIGNAL_MODEL_LOS_SIMPLE, SIGNAL_MODEL_LOS_MULTIPATH, SIGNAL_MODEL_ITM
#define SIGNAL_NAMES "Arcade", "LOS Simple", "LOS Multipath", "Longley-Rice (ITM) Experimental"
