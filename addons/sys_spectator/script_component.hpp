#define COMPONENT sys_spectator
#define COMPONENT_BEAUTIFIED Spectator
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_SPECTATOR
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_SPECTATOR
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_SPECTATOR
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#include "\a3\ui_f\hpp\defineResincl.inc"
#include "\a3\ui_f\hpp\defineCommonGrids.inc"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

#define POS_X(N) ((N) * GUI_GRID_W + GUI_GRID_CENTER_X)
#define POS_Y(N) ((N) * GUI_GRID_H + GUI_GRID_CENTER_Y)
#define POS_W(N) ((N) * GUI_GRID_W)
#define POS_H(N) ((N) * GUI_GRID_H)

#define IDC_RADIOS_GROUP 100
#define IDC_RADIOS_BACKGROUND 110
#define IDC_RADIOS_NONE 120
#define IDC_RADIOS_LIST 130

#define IDC_ACE_WIDGET 60030

#define ICON_CHECKED "\a3\3den\data\controls\ctrlcheckbox\texturechecked_ca.paa"
#define ICON_UNCHECKED "\a3\3den\data\controls\ctrlcheckbox\textureunchecked_ca.paa"
