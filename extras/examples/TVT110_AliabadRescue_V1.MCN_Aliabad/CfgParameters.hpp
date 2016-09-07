#define PARAM(TITLE) { title = TITLE; values[] = {""}; texts[] = {""}; default = 0; }

class Params {
	class Spacer0  PARAM("");
	class Spacer1  PARAM("Mission Settings:");
	class MaxOpforTeleport {
		title 		= "Max OPFOR Teleports";
		values[] 	= { 0,1,2,3,4,5,6 };
		texts[] 	= { "0", "1", "2", "3", "4", "5", "6"};
		default 	= 3;
		code 		= "MAX_TELEPORTS = %1;";
	};
	class RandomLanguages {
		title 		= "Randomize Bi-Lingual Players";
		values[] 	= { true, false };
		texts[] 	= { "Yes", "No" };
		default 	= false;
		code 		= "RANDOM_LANGUAGES = %1;";
	};
	
	class Spacer2  PARAM("");
	class Spacer3  PARAM("Environment Settings:");
	class GlobalViewDistance {
		title 		= "View Distance";
		values[] 	= { 600, 1200, 1500, 2000, 2500, 3000};
		texts[] 	= { "0.6 km", "1.2 km", "1.5 km", "2 km", "2.5 km", "3 km"};
		default 	= 3000;
		code 		= "setViewDistance %1;";
	};
	class TimeOfDay	{
		title 		= " Time of Day"; // 9999 is reserved for random weather
		values[] 	= { 9999, 0500, 0515, 0530, 0545, 0600, 0615, 0630, 0645, 0700, 0900, 1200, 1500, 1700, 1715, 1730, 1745, 1800, 1815, 1830, 1845, 1900 }; // 9999 is reserved for random time
		texts[] 	= { "Random", "0500", "0515", "0530", "0545", "0600", "0615", "0630", "0645", "0700", "0900", "1200", "1500", "1700", "1715", "1730", "1745", "1800", "1815", "1830", "1845", "1900" };
		default 	= 1500;
		code 		= "if (isServer) then {[%1] call compile (preprocessFileLineNumbers 'tb3\f\setTime.sqf')}";
	};

};