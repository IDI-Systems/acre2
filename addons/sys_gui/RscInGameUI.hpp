class RscInGameUI {
    class RscStanceInfo {
        controls[] += {"ACRE_AntennaElevationInfo"};
        class ACRE_AntennaElevationInfo: RscPictureKeepAspect {
            // TODO HEMTT Figure out quoting
            //x = IGUI_GRID_STANCE_X;
            //y = IGUI_GRID_STANCE_Y;
            //w = IGUI_GRID_STANCE_WAbs;
            onLoad = "uiNamespace setVariable ['ACRE_AntennaElevationInfo', _this select 0];";
            text = QPATHTOF(data\ui\stand_straight.paa);
            colorBackground[] = IGUI_BCG_COLOR;
        };
    };
};
