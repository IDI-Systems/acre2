#define COMPONENT sys_debug
#include "\idi\clients\acre\Addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_DEBUG
	#define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_DEBUG
	#define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_DEBUG
#endif

#include "\idi\clients\acre\Addons\main\script_macros.hpp"