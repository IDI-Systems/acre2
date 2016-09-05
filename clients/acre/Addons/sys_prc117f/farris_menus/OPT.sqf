#include "script_component.hpp"

GVAR(OPT) = ["OPT", "OPT", "",
	MENUTYPE_LIST,
	[
		[nil, "NOT COMPLETED", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
	],
    nil
];
[GVAR(OPT)] call FUNC(createMenu);


