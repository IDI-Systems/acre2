//fnc_getPosASLAtDistance.sqf
#include "script_component.hpp"

//private ["_unit" , "_storedPos", "_gamePos", "_alt", "_gen", "_returnPos"];
//_unit = _this;

(getPosASL _this);

/*_storedPos = _unit getVariable ["ap", []];
_gamePos = (getPosASL _unit);
_alt = getTerrainHeightASL [(_gamePos select 0), (_gamePos select 1)];
if(_gamePos select 2 < 0) then {
	_gamePos set[2, _alt];
};
_gen = false;
_returnPos = [];
if(_unit != acre_player) then {
	if((count _storedPos) > 0 && (_unit isKindOf "Man" && _unit in (playableUnits + switchableUnits + ACRE_getAllCuratorObjects))) then {
		if((_storedPos distance _gamePos) < 5 && (_alt > 0 && ((_gamePos select 0)-_alt) < 0)) then {
			// acre_player sideChat format["1"];
			_returnPos = _storedPos;
		} else {
			if(((_storedPos distance _gamePos) > 100 || (_unit distance acre_player) > 100) && (vehicle acre_player) != (vehicle _unit)) then {
				// acre_player sideChat format["2"];
				_returnPos = _storedPos;
			} else {
				_gen = true;
				// acre_player sideChat format["3"];
				_unit setVariable ["ap", _gamePos];
				_returnPos = _gamePos;
			};
		};
	} else {
		_gen = true;
		// acre_player sideChat format["4"];
		_unit setVariable ["ap", _gamePos];
		_returnPos = _gamePos;
	};
} else {
	_gen = true;
	// acre_player sideChat format["5"];
	_unit setVariable ["ap", _gamePos];
	_returnPos = _gamePos;
};
// diag_log text format["POSAB: %1=%2 %3", _unit, _returnPos, _gen];
+_returnPos;*/
