#define COMPONENT sys_io
#define COMPONENT_BEAUTIFIED Input/Output
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_IO
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_IO
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_IO
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

// The voice extension (acre_voice_x64), and the name its ExtensionCallbacks use.
#define EXTENSION_NAME "acre_voice"
// Seconds between token requests while not connected.
#define TOKEN_RETRY_INTERVAL 10
