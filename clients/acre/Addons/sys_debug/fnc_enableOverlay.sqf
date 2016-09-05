//fnc_enableOverlay.sqf
#include "script_component.hpp"

if(!ACRE_OVERLAY_ENABLED) then {
    ACRE_OVERLAY_ENABLED = true;
    private _display = (findDisplay 46);
    private _idStart = 26033;
    private _offset = 5;
    for "_i" from 0 to (count playableUnits)*2 do {
        ACRE_DEBUG_OVERLAYS pushBack [(_display ctrlCreate ["RscStructuredText", _idStart + _offset*_i + 0]), (_display ctrlCreate ["RscText", _idStart + _offset*_i + 1])];
    };
    ADDPFH({ _this call FUNC(debugOverlay) }, 0, []);
};

