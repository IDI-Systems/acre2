#include "script_component.hpp"

GVAR(MODE) = ["MODE", "MODE", "MODE",
	MENUTYPE_LIST,
	[
		[nil, "NORM", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
		[nil, "DAMA", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
		[nil, "SCAN", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
		[nil, "CLONE", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
		[nil, "TEST", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
		[nil, "REMOTE CONTROL", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ],
		[nil, "BEACON", "", MENU_ACTION_SUBMENU, ["ERROR_NOENTRY"], nil ]
	],
    nil
];
[GVAR(MODE)] call FUNC(createMenu);
