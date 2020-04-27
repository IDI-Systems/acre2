class RscInGameUI {
    class RscStanceInfo {
        idd = 303;
        scriptName = "RscStanceInfo";
        scriptPath = "IGUI";
        onLoad = "['onLoad', _this, 'RscStanceInfo', 'IGUI'] call (uiNamespace getVariable 'BIS_fnc_initDisplay')";
        onUnload = "['onUnload', _this, 'RscStanceInfo', 'IGUI'] call (uiNamespace getVariable 'BIS_fnc_initDisplay')";
        controls[] = {
            "StanceIndicatorBackground",
            "StanceIndicator",
            "AntennaElevationInfoControlsGroup"
        };
        class StanceIndicatorBackground: RscPicture {
            colorText[] = {
                "(profilenamespace getVariable ['IGUI_BCG_RGB_R', 0])",
                "(profilenamespace getVariable ['IGUI_BCG_RGB_G', 1])",
                "(profilenamespace getVariable ['IGUI_BCG_RGB_B', 1])",
                "(profilenamespace getVariable ['IGUI_BCG_RGB_A', 0.8])"
            };
            idc = 1201;
            text = "\A3\Ui_f\data\IGUI\RscIngameUI\RscUnitInfo\gradient_ca.paa";
            x = "(profilenamespace getVariable ['IGUI_GRID_STANCE_X', ((safezoneX + safezoneW) - (3.7 * (((safezoneW / safezoneH) min 1.2) / 40)) - 0.5 * (((safezoneW / safezoneH) min 1.2) / 40))])";
            y = "(profilenamespace getVariable ['IGUI_GRID_STANCE_Y', (safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
            w = "(3.7 * (((safezoneW / safezoneH) min 1.2) / 40))";
            h = "(3.7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))";
        };
        class StanceIndicator: RscPictureKeepAspect {
            idc = 188;
            text = "\A3\Ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_stand_ca.paa";
            x = "(profilenamespace getVariable ['IGUI_GRID_STANCE_X', ((safezoneX + safezoneW) - (3.7 * (((safezoneW / safezoneH) min 1.2) / 40)) - 0.5 * (((safezoneW / safezoneH) min 1.2) / 40))])";
            y = "(profilenamespace getVariable ['IGUI_GRID_STANCE_Y', (safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
            w = "(3.7 * (((safezoneW / safezoneH) min 1.2) / 40))";
            h = "(3.7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))";
        };

        class AntennaElevationInfoControlsGroup: RscControlsGroupNoScrollbars {
            idc = 200;
            x = "profileNamespace getVariable ['IGUI_grid_ACRE_antennaElevationInfo_X', profilenamespace getVariable ['IGUI_GRID_STANCE_X', ((safezoneX + safezoneW) - (3.7 * (((safezoneW / safezoneH) min 1.2) / 40)) - 0.5 * (((safezoneW / safezoneH) min 1.2) / 40))]]";
            y = "profileNamespace getVariable ['IGUI_grid_ACRE_antennaElevationInfo_Y', profilenamespace getVariable ['IGUI_GRID_STANCE_Y', (safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))]]";
            w = "3.7 * (((safezoneW / safezoneH) min 1.2) / 40)";
            onLoad = "uiNamespace setVariable ['ACRE_AntennaElevationInfo', _this select 0];";

            class Controls {
                class AntennaElevationInfo: RscPictureKeepAspect {
                    idc = 201;
                    x = 0;
                    y = 0;
                    w = "3.7 * (((safezoneW / safezoneH) min 1.2) / 40)";
                    text= QPATHTOF(data\ui\stand_straight.paa);
                    colorBackground[] = {
                        "profileNamespace getVariable ['IGUI_BCG_RGB_R', 0]",
                        "profileNamespace getVariable ['IGUI_BCG_RGB_G', 1]",
                        "profileNamespace getVariable ['IGUI_BCG_RGB_B', 1]",
                        "profileNamespace getVariable ['IGUI_BCG_RGB_A', 0.8]"
                    };
                };
            };
        };
    };
};
