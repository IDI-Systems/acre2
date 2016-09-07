#include "script_component.hpp"

_endingType = _this select 0;

FUNC(showEnding) = {
	private["_winningSide", "_endingTitle", "_endingReason", "_endText"];
	_winningSide = _this select 0;
	_endingTitle = _this select 1;
	_endingReason = _this select 2;
	
	_endText = format["%1\n\n\n%2", _endingTitle, _endingReason];
	titleFadeOut 0.1;
	titleText [_endText, "BLACK", 2];
	
	[_winningSide] spawn {
		private["_winningSide"];
		_winningSide = _this select 0;
		sleep 20;
		if((side player) == civilian && _winningSide == west) then {
			endMission "End1";
		} else {
			if( (side player) == _winningSide) then {
				endMission "End1";
			} else {
				failMission "Loser";
			};
		};
	};
};

switch _endingType do {
	case 'rescue': { [west, "US Army Mission Accomplished", "The Survivors have been rescued!"] call FUNC(showEnding); };
	case 'opforDeath': { [west, "US Army Victory, The Russian forces have been destroyed", "Russian forces have become combat ineffective."] call FUNC(showEnding);};
	
	case 'timeLimit': { [east, "Russian Victory, The US Forces failed to rescue the survivors", "The time limit has been exceeded."] call FUNC(showEnding);};
	case 'bluforDeath': { [east, "Russian Victory, The US Forces failed to rescue the survivors", "US Army forces have become combat ineffective."] call FUNC(showEnding);};
	case 'hvtDeath': { [east, "Russian Victory, The US Forces failed to rescue the survivors", "The crash survivors died."] call FUNC(showEnding);};
};
