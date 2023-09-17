#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    DGVAR(showSignalHint) = false;
    DGVAR(terrainScaling) = 1;
    DGVAR(omnidirectionalRadios) = 0;
};

// CBA Settings
#include "initSettings.sqf"

DGVAR(lrAntennas) = []; // array of antenna classname segments that count as long-ranged, i.e: "ACRE_123CM_VHF_TNC" should be "123CM" in the array.
if !(GVAR(signalModel) isEqualTo GVAR(signalModelLR)) then { // start building the array of antenna classname segments based on the current ACRE Signal CBA settings
    if (GVAR(radiopacksLR)) then {
        GVAR(lrAntennas) append ["SEM70", "AT271", "123CM"];
    };

    if (GVAR(racksLR)) then {
        GVAR(lrAntennas) append ["270CM", "FA80", "AS1729"];
    };

    if (GVAR(groundSpikeLR) != 0) then {
        if (GVAR(groundSpikeLR) == 1) exitWith { // Only GSA with Mast is long-ranged
            GVAR(lrAntennas) append ["643CM"];
        };
        if (GVAR(groundSpikeLR) == 2) exitWith { // Both GSA with and without Masts are long-ranged
            GVAR(lrAntennas) append ["243CM", "643CM"];
        };
    };
    INFO_1("Antennas that use signalModelLR: %1", GVAR(lrAntennas));
};

ADDON = true;
