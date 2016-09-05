//fnc_handleModeButton.sqf
#include "script_component.hpp"

private ["_alt"];
_alt = _this select 7;
if(_alt) then {
    [GVAR(currentRadioId), "ProgrammingDisplay"] call FUNC(changeState);
} else {
    [GVAR(currentRadioId), "ModeDisplay"] call FUNC(changeState);
};
