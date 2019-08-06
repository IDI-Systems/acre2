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

#include "\a3\ui_f\hpp\defineCommonGrids.inc"

#define POS_X(N) ((N) * GUI_GRID_W + GUI_GRID_CENTER_X)
#define POS_Y(N) ((N) * GUI_GRID_H + GUI_GRID_CENTER_Y)
#define POS_W(N) ((N) * GUI_GRID_W)
#define POS_H(N) ((N) * GUI_GRID_H)

#define VOLUME_CONTROL_DEFAULT_X POS_X(14)
#define VOLUME_CONTROL_DEFAULT_Y POS_Y(20)
#define VOLUME_CONTROL_DEFAULT_W POS_W(12)
#define VOLUME_CONTROL_DEFAULT_H POS_H(0.9)

#define VOLUME_CONTROL_LAYER (QGVAR(VolumeControl) call BIS_fnc_rscLayer)

// Color scale for the volume control (yellow -> orange -> red)
#define VOLUME_COLOR_SCALE [ \
    [1, 1, 0, 0.5], \
    [1, 0.83, 0, 0.5], \
    [1, 0.65, 0, 0.5], \
    [1, 0.44, 0, 0.5], \
    [1, 0, 0, 0.5] \
]

// Amount that the volume level changes on every scroll wheel action
#define VOLUME_LEVEL_CHANGE 0.25

#define INVENTORY_DISPLAY (findDisplay 602)

#define IDC_FG_VEST_CONTAINER 638
#define IDC_FG_UNIFORM_CONTAINER 633
#define IDC_FG_BACKPACK_CONTAINER 619
#define IDC_FG_GROUND_ITEMS 632
#define IDC_FG_CHOSEN_CONTAINER 640

#define IDC_RADIOSLOT 6214

#define INV_SELECTION_CHANGED 0
#define INV_DOUBLE_CLICK 1
