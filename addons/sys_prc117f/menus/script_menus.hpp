
// Dialog info
#define LARGE_ROW_COUNT 25
#define SMALL_ROW_COUNT 25

// Menu Types
#define MENUTYPE_LIST                 1
#define MENUTYPE_ACTIONSERIES         2
#define MENUTYPE_NUMBER                3
#define MENUTYPE_ALPHANUMERIC         4
#define MENUTYPE_SELECTION            5
#define MENUTYPE_DISPLAY            6
#define MENUTYPE_STATIC                7
#define MENUTYPE_FREQUENCY            8

// Constants for switches
#define MENU_ACTION_NONE        50
#define MENU_ACTION_SUBMENU        51
#define MENU_ACTION_CODE        52

// Limits
#define MAX_MENU_ITEMS_PER_PAGE 6

// Menu Data Accessors
#define MENU_ID(x) (x select 0)
#define MENU_DISPLAYNAME(x) (x select 1)
#define MENU_PATHNAME(x) (x select 2)
#define MENU_TYPE(x) (x select 3)
#define MENU_SUBMENUS(x) (x select 4)

#define MENU_SUBMENUS_ITEM(menu, index) (MENU_SUBMENUS(menu) select index)

#define MENU_ACTION_EVENTS(menu) (menu select 5)
#define MENU_ACTION_ONENTRY(menu) ((menu select 5) select 0)
#define MENU_ACTION_ONCOMPLETE(menu) ((menu select 5) select 1)
#define MENU_ACTION_ONBUTTONPRESS(menu) ((menu select 5) select 2)
#define MENU_ACTION_ONRENDER(menu) ((menu select 5) select 3)
#define MENU_ACTION_ONACTIONCOMPLETE(menu) ((menu select 5) select 4)

#define MENU_ACTION_SERIESCOMPLETE(menu) (menu select 6)
#define MENU_SELECTION_DISPLAYSET(menu) (menu select 6)
#define MENU_SELECTION_VARIABLE(menu) (menu select 7)


#define ADD_MENU(menuObj) HASH_SET(GVAR(Menus),MENU_ID(menuObj),menuObj)

#define MENU_SET_PARENT_ID(submenu, menu) submenu pushBack MENU_ID(menu)
#define MENU_PARENT_ID(menu) (menu select ((count menu)-1))
#define MENU_PARENT(menu) (HASH_GET(GVAR(Menus),MENU_PARENT_ID(menu)))

#define ALIGN_LEFT 1
#define ALIGN_RIGHT 2
#define ALIGN_CENTER 3

// Dialog defition fun
#define ICON_BATTERY   99991
#define ICON_LOADING   99992
#define ICON_LOGO      99993
#define ICON_VOLUME    99994
#define ICON_TRANSMITBAR 99995
#define ICON_KNOB      99901
#define ICON_TRANSMIT  99902
#define ICON_UP        99903
#define ICON_DOWN      99904
#define ICON_UPDOWN    99905
#define ICON_SCROLLBAR 99906

#define ROWS_SMALL 5
#define ROWS_LARGE 4

#define COLUMNS_XXLARGE 12
#define COLUMNS_XLARGE 15
#define COLUMNS_LARGE 23
#define COLUMNS_SMALL 32

#define ROW_SMALL_1 11
#define ROW_SMALL_2 12
#define ROW_SMALL_3 13
#define ROW_SMALL_4 14
#define ROW_SMALL_5 15

#define ROW_LARGE_1 21
#define ROW_LARGE_2 22
#define ROW_LARGE_3 23
#define ROW_LARGE_4 24

#define ROW_XLARGE_1 31
#define ROW_XLARGE_2 32

#define ROW_XXLARGE_1 41
