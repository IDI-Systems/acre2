// Event Handlers

#define QUOTE(var1) #var1

class Extended_PreInit_EventHandlers {
	class uo_aliabadRescue {
		init = QUOTE( call compile preprocessFileLineNumbers 'XEH_preinit.sqf' );
	};
	class tb3 {
		init = QUOTE( call compile preprocessFileLineNumbers 'tb3\preInit.sqf' );
	};
};

class Extended_PostInit_EventHandlers {
	class uo_aliabadRescue {
		 init = QUOTE( call compile preprocessFileLineNumbers 'XEH_postinit.sqf' );
	};
};

// Unit specific events
class Extended_Killed_EventHandlers {
	class Man {
		class uo_aliabadRescue {
			killed = QUOTE( call compile preprocessFileLineNumbers 'onPlayerDeath.sqf' );
		};
	};
};