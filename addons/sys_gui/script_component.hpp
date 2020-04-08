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
#include "\a3\ui_f\hpp\defineCommonColors.inc"

#define POS_X(N) ((N) * GUI_GRID_W + GUI_GRID_CENTER_X)
#define POS_Y(N) ((N) * GUI_GRID_H + GUI_GRID_CENTER_Y)
#define POS_W(N) ((N) * GUI_GRID_W)
#define POS_H(N) ((N) * GUI_GRID_H)

// Volume Control
#define VOLUME_CONTROL_DEFAULT_X POS_X(14)
#define VOLUME_CONTROL_DEFAULT_Y POS_Y(20)
#define VOLUME_CONTROL_DEFAULT_W POS_W(12)
#define VOLUME_CONTROL_DEFAULT_H POS_H(0.9)

#define VOLUME_CONTROL_LAYER (QGVAR(VolumeControl) call BIS_fnc_rscLayer)

// Color scales for the volume control
#define VOLUME_COLOR_SCALE_YELLOW_ORANGE_RED [ \
    [1, 1, 0, 0.5], \
    [1, 0.83, 0, 0.5], \
    [1, 0.65, 0, 0.5], \
    [1, 0.44, 0, 0.5], \
    [1, 0, 0, 0.5] \
]

#define VOLUME_COLOR_SCALE_GREEN_ORANGE_RED [ \
    [1, 1, 1, 0.5], \
    [0.96, 1, 0, 0.5], \
    [0.61, 0.8, 0, 0.5], \
    [1, 0.46, 0, 0.5], \
    [1, 0, 0, 0.5] \
]

#define VOLUME_COLOR_SCALE_BLUE_MAGENTA_RED [ \
    [0, 0, 0.7, 0.5], \
    [0.6, 0, 0.76, 0.5], \
    [0.84, 0, 0.46, 0.5], \
    [0.9, 0, 0, 0.5] \
]

// Amount that the volume level changes on every scroll wheel action
#define VOLUME_LEVEL_CHANGE 0.25


// Inventory
#define INVENTORY_DISPLAY (findDisplay 602)
#define IDC_RADIOSLOT 6214
#define IDC_FG_GROUND_ITEMS 632
#define IDC_FG_CHOSEN_CONTAINER 640


// Using base definitions due to UI grids using BIS_fnc_parseNumberSafe
// which believes profileNamespace/getVariable are unsafe and defaults to 0
// https://feedback.bistudio.com/T142860
#define VEHICLE_INFO_DEFAULT_X IGUI_GRID_VEHICLE_XDef
#define VEHICLE_INFO_DEFAULT_Y IGUI_GRID_VEHICLE_YDef + 4.3 * IGUI_GRID_VEHICLE_H
#define VEHICLE_INFO_DEFAULT_W IGUI_GRID_VEHICLE_WAbs
#define VEHICLE_INFO_DEFAULT_H IGUI_GRID_VEHICLE_H
