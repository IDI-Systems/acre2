#define COMPONENT sys_list
#define COMPONENT_BEAUTIFIED List
#include "\idi\acre\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_SYS_LIST
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_LIST
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_LIST
#endif

#include "\idi\acre\addons\main\script_macros.hpp"
#include "\idi\acre\addons\main\script_dialog_defines.hpp"
#include "script_dialog_defines.hpp"

#include "\a3\ui_f\hpp\defineResincl.inc"
#define IDD_RSCDISPLAYEGSPECTATOR 60492 // \a3\ui_f\hpp\defineResinclDesign.inc has duplicates (pboProject no like)
#define IDD_RSCDISPLAYCURATOR 312 // \a3\ui_f_curator\ui\defineResinclDesign.inc has duplicates (pboProject no like)
