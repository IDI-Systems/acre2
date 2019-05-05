#include "script_component.hpp"

if (!hasInterface) exitWith {};

[{
    if (ACRE_MAP_LOADED && {[] call FUNC(isInitialized)}) then {
        diag_log "ACRE initialized throw";
        systemChat "ACRE initialized throw";
        [_this select 1] call CBA_fnc_removePerFrameHandler;
        ["acre_initialized"] call CBA_fnc_localEvent;
    };
}, 0, []] call CBA_fnc_addPerFrameHandler;
