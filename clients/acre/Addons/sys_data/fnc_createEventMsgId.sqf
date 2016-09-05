//fnc_createEventMsgId.sqf
#include "script_component.hpp"

private _valid = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
private _idString = "";
for "_i" from 1 to 8 do {
	_idString = _idString + (_valid select (floor(random 15)));
};
_idString = (str diag_tickTime)+_idString;
_idString;
