#include "script_component.hpp"

// Force add PRC77 to RTO backpacks in SOG:PF coop campaign
if (hasInterface && {getText (missionConfigFile >> "Header" >> "gameType") == "sogpf"}) then {
    [{!isNull player}, {
        if (backpack player in PRC77_BACKPACKS) then {
            backpackContainer player addItemCargoGlobal ["ACRE_PRC77", 1];
        };
    }] call CBA_fnc_waitUntilAndExecute;
};
