#define COMPONENT sys_signal
#include "\idi\clients\acre\addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_SIGNAL
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_SIGNAL
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SIGNAL
#endif

#include "\idi\clients\acre\addons\main\script_macros.hpp"

#define EOL_CHAR toString[10]

#define ADDLINE(pos1, pos2) ACRE_SIGNAL_TEST_LINES pushBack [pos1, pos2]
#define ADDLINECOLOR(pos1, pos2, color) ACRE_SIGNAL_TEST_LINES pushBack [pos1, pos2, color]
#define ADDICON(pos, text)    ACRE_SIGNAL_TEST_ICONS pushBack [pos, text]
#define C(r, g, b, a)    [r, g, b, a]

#define MAX_RETURNS 20
