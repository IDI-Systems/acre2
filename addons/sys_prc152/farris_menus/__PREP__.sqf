#include "script_component.hpp"

// Prepare the menus
#define MENU_DEFINITION(folder,menu) [] call compile preprocessFileLineNumbers QPATHTOF(folder\menu.sqf);

MENU_DEFINITION(farris_menus,Loading);
MENU_DEFINITION(farris_menus,Main);
MENU_DEFINITION(farris_menus,PGM);
MENU_DEFINITION(farris_menus,OPT);
