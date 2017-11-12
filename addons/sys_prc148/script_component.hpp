#define COMPONENT sys_prc148
#define COMPONENT_BEAUTIFIED AN/PRC-148
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_PRC148
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_ENABLED_SYS_PRC148
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_PRC148
#endif

#include "\idi\acre\addons\main\script_macros.hpp"

#define NAME_PRC148 AN/PRC-148
//#define NAME_PRC148_UHF AN/PRC-148 UHF

#include "\idi\acre\addons\sys_components\script_acre_component_defines.hpp"
#include "\idi\acre\addons\sys_rack\script_acre_rack_defines.hpp"

#define BIG_LINE_1 50000
#define BIG_LINE_2 51000
#define BIG_LINE_3 52000
#define BIG_LINE_4 53000

#define SMALL_LINE_1 54000
#define SMALL_LINE_2 55000
#define SMALL_LINE_3 56000
#define SMALL_LINE_4 57000
#define SMALL_LINE_5 58000

#define ICON_BATSTRENGTH 12010
#define ICON_BATTERY 12011
#define ICON_SQUELCH 12012
#define ICON_EXTERNAL 12013
#define ICON_SIDECONNECTOR 12014

#define MENU_TYPE_TEXT 0
#define MENU_TYPE_LIST 1
#define MENU_TYPE_MENU 2
#define MENU_TYPE_NUM 3

#define MENU_MOVE_UP -1
#define MENU_MOVE_DOWN 1

#define LEFT_ALIGN 0
#define CENTER_ALIGN 1
#define RIGHT_ALIGN 2

#define PAGE_INDEX ([GVAR(currentRadioId), "getState", "menuPage"] call EFUNC(sys_data,dataEvent))
#define MENU_INDEX ([GVAR(currentRadioId), "getState", "menuIndex"] call EFUNC(sys_data,dataEvent))
#define ENTRY_INDEX ([GVAR(currentRadioId), "getState", "entryCursor"] call EFUNC(sys_data,dataEvent))
#define SELECTED_ENTRY ([GVAR(currentRadioId), "getState", "selectedEntry"] call EFUNC(sys_data,dataEvent))

#define SET_PAGE_INDEX(index) [GVAR(currentRadioId), "setState", ["menuPage", index]] call EFUNC(sys_data,dataEvent)
#define SET_MENU_INDEX(index) [GVAR(currentRadioId), "setState", ["menuIndex", index]] call EFUNC(sys_data,dataEvent)
#define SET_ENTRY_INDEX(index) [GVAR(currentRadioId), "setState", ["entryCursor", index]] call EFUNC(sys_data,dataEvent)
#define SET_SELECTED_ENTRY(index) [GVAR(currentRadioId), "setState", ["selectedEntry", index]] call EFUNC(sys_data,dataEvent)

#define GET_DISPLAY (uiNamespace getVariable QGVAR(currentDisplay))

#define SET_TEXT(text, row, start, length) [_display, row, [start, start+length-1], text] call FUNC(setText)

#define MAIN_DISPLAY (findDisplay 31337)
