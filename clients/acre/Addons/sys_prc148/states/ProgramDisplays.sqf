#include "\idi\clients\acre\addons\sys_prc148\script_component.hpp"

DFUNC(ProgramDisplay_Render) = {
	params["_display"];

	GVAR(currentMenu) = 
	[
		[
			["GLOBAL", "GLOBAL", BIG_LINE_1, [2, 11], MENU_TYPE_MENU, FUNC(AccessDeniedState)],
			["CHANNEL", "CHANNEL", BIG_LINE_2, [2, 11], MENU_TYPE_MENU, { [GVAR(currentRadioId), "ChannelDisplay"] call FUNC(changeState); }],
			["EMERGENCY", "EMERGENCY", BIG_LINE_3, [2, 11], MENU_TYPE_MENU, FUNC(AccessDeniedState)],
			["GROUP", "GROUP", BIG_LINE_4, [2, 11], MENU_TYPE_MENU, FUNC(AccessDeniedState)]
		],
		[
			["IW", "IW", BIG_LINE_1, [2, 11], MENU_TYPE_MENU, FUNC(AccessDeniedState)]
		]
	];
	
	[_display, GVAR(currentMenu)] call FUNC(showMenu);		
};

DFUNC(ProgramDisplay_ESC) = {
	[GVAR(currentRadioId), "ProgrammingDisplay"] call FUNC(changeState);
};