class CfgPatches {
    class acre_game {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.01;
        requiredAddons[] = { "A3_Weapons_F", "Extended_EventHandlers", "CBA_MAIN", "CBA_common" };
        author = "ACRE2 Team";
    };
};


#include "CfgWeapons.hpp"
#include "CfgEventhandlers.hpp"

class CfgLocationTypes {
    class AcreHashType {
        color[] = {0,0,0,0};
        drawStyle = "acre";
        font = "PuristaMedium";
        importance = 0;
        name = "acre";
        shadow = 0;
        size = 0;
        textSize = 0.0;
        texture = "";
    };
};
