// Redefine from a3/ui_f/hpp/defineCommonGrids.inc to allow use in quotes
#undef IGUI_GRID_STANCE_X
#undef IGUI_GRID_STANCE_Y
#define acre_IGUI_GRID_STANCE_X (profilenamespace getvariable ['IGUI_GRID_STANCE_X',IGUI_GRID_STANCE_XDef])
#define acre_IGUI_GRID_STANCE_Y (profilenamespace getvariable ['IGUI_GRID_STANCE_Y',IGUI_GRID_STANCE_YDef])

class RscInGameUI {
    class RscStanceInfo {
        controls[] += {"ACRE_AntennaElevationInfo"};
        class ACRE_AntennaElevationInfo: RscPictureKeepAspect {
            x = QUOTE(acre_IGUI_GRID_STANCE_X);
            y = QUOTE(acre_IGUI_GRID_STANCE_Y);
            w = QUOTE(IGUI_GRID_STANCE_WAbs);
            onLoad = "uiNamespace setVariable ['ACRE_AntennaElevationInfo', _this select 0];";
            text = QPATHTOF(data\ui\stand_straight.paa);
            colorBackground[] = IGUI_BCG_COLOR;
        };
    };
};
