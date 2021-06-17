#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

[] call FUNC(preset_information);

ADDON = true;

if (hasInterface) then {
    GVAR(currentRadioId) = -1;

    DGVAR(backgroundImages) = [
        QPATHTOF(Data\anim\bf888s_anim0000.paa),
        QPATHTOF(Data\anim\bf888s_anim0001.paa),
        QPATHTOF(Data\anim\bf888s_anim0002.paa),
        QPATHTOF(Data\anim\bf888s_anim0003.paa),
        QPATHTOF(Data\anim\bf888s_anim0004.paa),
        QPATHTOF(Data\anim\bf888s_anim0005.paa),
        QPATHTOF(Data\anim\bf888s_anim0006.paa),
        QPATHTOF(Data\anim\bf888s_anim0007.paa),
        QPATHTOF(Data\anim\bf888s_anim0008.paa),
        QPATHTOF(Data\anim\bf888s_anim0009.paa),
        QPATHTOF(Data\anim\bf888s_anim0010.paa),
        QPATHTOF(Data\anim\bf888s_anim0011.paa),
        QPATHTOF(Data\anim\bf888s_anim0012.paa),
        QPATHTOF(Data\anim\bf888s_anim0013.paa),
        QPATHTOF(Data\anim\bf888s_anim0014.paa),
        QPATHTOF(Data\anim\bf888s_anim0015.paa),
        QPATHTOF(Data\anim\bf888s_anim0016.paa),
        QPATHTOF(Data\anim\bf888s_anim0017.paa),
        QPATHTOF(Data\anim\bf888s_anim0018.paa),
        QPATHTOF(Data\anim\bf888s_anim0019.paa),
        QPATHTOF(Data\anim\bf888s_anim0020.paa),
        QPATHTOF(Data\anim\bf888s_anim0021.paa),
        QPATHTOF(Data\anim\bf888s_anim0022.paa),
        QPATHTOF(Data\anim\bf888s_anim0023.paa),
        QPATHTOF(Data\anim\bf888s_anim0024.paa),
        QPATHTOF(Data\anim\bf888s_anim0025.paa),
        QPATHTOF(Data\anim\bf888s_anim0026.paa),
        QPATHTOF(Data\anim\bf888s_anim0027.paa),
        QPATHTOF(Data\anim\bf888s_anim0028.paa),
        QPATHTOF(Data\anim\bf888s_anim0029.paa),
        QPATHTOF(Data\anim\bf888s_anim0030.paa),
        QPATHTOF(Data\anim\bf888s_anim0031.paa),
        QPATHTOF(Data\anim\bf888s_anim0032.paa),
        QPATHTOF(Data\anim\bf888s_anim0033.paa),
        QPATHTOF(Data\anim\bf888s_anim0034.paa),
        QPATHTOF(Data\anim\bf888s_anim0035.paa)
    ];
};

ADDON = true;
