#define COMPONENT sys_modules
#define COMPONENT_BEAUTIFIED Modules
#include "\idi\acre\addons\main\script_mod.hpp"

// #define USE_DEBUG_EXTENSIONS
// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_MODULES
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_MODULES
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_MODULES
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

#define POS_X(N) ((N) * GUI_GRID_W + GUI_GRID_CENTER_X)
#define POS_Y(N) ((N) * GUI_GRID_H + GUI_GRID_CENTER_Y)
#define POS_W(N) ((N) * GUI_GRID_W)
#define POS_H(N) ((N) * GUI_GRID_H)

#define IDC_LANGUAGES 6800
#define IDC_LIST 6801
#define IDC_ID_BAR 68032
#define IDC_NAME_BAR 6803
