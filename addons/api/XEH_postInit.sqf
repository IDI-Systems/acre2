#include "script_component.hpp"

if (!hasInterface) exitWith {};

[{
    if (ACRE_MAP_LOADED && {[] call FUNC(isInitialized)}) then {
        [_this select 1] call CBA_fnc_removePerFrameHandler;
        ["acre_initialized"] call CBA_fnc_localEvent;
    };
}, 0, []] call CBA_fnc_addPerFrameHandler;
