#define COMPONENT sys_gui
#define COMPONENT_BEAUTIFIED GUI
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_GUI
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_GUI
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_GUI
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define INVENTORY_DISPLAY (findDisplay 602)

#define IDC_FG_VEST_CONTAINER 638
#define IDC_FG_UNIFORM_CONTAINER 633
#define IDC_FG_BACKPACK_CONTAINER 619
#define IDC_FG_GROUND_ITEMS       632
#define IDC_FG_CHOSEN_CONTAINER  640

#define IDC_RADIOSLOT 6214

#define INV_SELECTION_CHANGED 0
#define INV_DOUBLE_CLICK 1
