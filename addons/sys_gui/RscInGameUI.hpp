class RscInGameUI {
    class RscStanceInfo {
        controls[] += {"ACRE_AntennaElevationInfo"};
        class ACRE_AntennaElevationInfo: RscPictureKeepAspect {
            x = IGUI_GRID_STANCE_X;
            y = IGUI_GRID_STANCE_Y;
            w = IGUI_GRID_STANCE_WAbs;
            onLoad = "uiNamespace setVariable ['ACRE_AntennaElevationInfo', _this select 0];";
            text = QPATHTOF(data\ui\stand_straight.paa);
            colorBackground[] = {
                "profileNamespace getVariable ['IGUI_BCG_RGB_R', 0]",
                "profileNamespace getVariable ['IGUI_BCG_RGB_G', 1]",
                "profileNamespace getVariable ['IGUI_BCG_RGB_B', 1]",
                "profileNamespace getVariable ['IGUI_BCG_RGB_A', 0.8]"
            };
        };
    };
};
