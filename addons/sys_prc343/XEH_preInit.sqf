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
        QUOTE(PATHTOF(Data\anim\prc343_anim0000.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0001.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0002.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0003.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0004.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0005.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0006.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0007.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0008.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0009.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0010.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0011.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0012.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0013.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0014.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0015.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0016.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0017.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0018.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0019.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0020.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0021.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0022.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0023.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0024.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0025.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0026.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0027.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0028.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0029.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0030.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0031.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0032.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0033.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0034.paa)),
        QUOTE(PATHTOF(Data\anim\prc343_anim0035.paa))
    ];
};

ADDON = true;
