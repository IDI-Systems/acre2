#include "script_component.hpp"

ADDON = false;

// Filter respawn loadouts saved via SOG:PF system
if (isNil "vn_ms_respawnLoadout_filters") then {
    vn_ms_respawnLoadout_filters = [];
};
vn_ms_respawnLoadout_filters pushBack {[_this] call acre_api_fnc_filterUnitLoadout};

ADDON = true;
