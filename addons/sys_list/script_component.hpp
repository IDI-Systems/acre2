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

#undef ST_TITLE_BAR
#undef ST_TILE_PICTURE
#undef ST_FRAME
#undef ST_DOWN
#undef ST_BACKGROUND
#undef CT_XKEYDESC
#undef CT_OBJECT
#undef CT_STRUCTURED_TEXT
#undef CT_TOOLBOX
#undef ST_MULTI
#undef ST_PICTURE
#undef CT_HTML
#undef ST_GROUP_BOX
#undef ST_NO_RECT
#undef ST_HPOS
#undef CT_MAP_MAIN
#undef CT_SLIDER
#undef CT_XCOMBO
#undef CT_STATIC
#undef CT_BUTTON
#undef ST_UP
#undef CT_CONTROLS_GROUP
#undef CT_USER
#undef ST_TYPE
#undef ST_VPOS
#undef CT_MAP
#undef CT_XSLIDER
#undef ST_VCENTER
#undef ST_SHADOW
#undef ST_WITH_RECT
#undef CT_LINEBREAK
#undef CT_ANIMATED_TEXTURE
#undef CT_LISTBOX
#undef ST_HUD_BACKGROUND
#undef ST_KEEP_ASPECT_RATIO
#undef CT_ACTIVETEXT
#undef CT_CHECKBOXES
#undef CT_PROGRESS
#undef CT_OBJECT_CONT_ANIM
#undef ST_POS
#undef CT_LISTNBOX
#undef CT_TREE
#undef CT_SHORTCUTBUTTON
#undef ST_CENTER
#undef CT_CONTEXT_MENU
#undef ST_LEFT
#undef ST_SINGLE
#undef ST_GROUP_BOX2
#undef CT_XBUTTON
#undef CT_OBJECT_CONTAINER
#undef CT_XLISTBOX
#undef CT_STATIC_SKEW
#undef CT_OBJECT_ZOOM
#undef CT_COMBO
#undef ST_RIGHT
#undef ST_LINE
#undef CT_EDIT

#include "\a3\ui_f\hpp\defineResincl.inc"
#define IDD_RSCDISPLAYEGSPECTATOR 60492 // \a3\ui_f\hpp\defineResinclDesign.inc has duplicates (pboProject no like)
#define IDD_RSCDISPLAYCURATOR 312 // \a3\ui_f_curator\ui\defineResinclDesign.inc has duplicates (pboProject no like)
