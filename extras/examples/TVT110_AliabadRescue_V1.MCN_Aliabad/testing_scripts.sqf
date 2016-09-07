[] spawn {
	["sideReady", [east] ] call CBA_fnc_globalEvent;
	sleep 5;
	["sideReady", [west] ] call CBA_fnc_globalEvent;
};


["missionEnd", ["rescue"] ] call CBA_fnc_globalEvent;