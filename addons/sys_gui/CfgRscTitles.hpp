#include "MyDialogDefines.hpp"

class RscXSliderH;
class RscText;
class RscStructuredText;
class RscControlsGroupNoScrollbars;
class RscPicture;
class RscPictureKeepAspect;

class RscIngameUI {
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

class RscTitles {
    class GVAR(VolumeControlDialog)  {
        idd = -1;
        movingEnable = 1;
        duration = 9999999;
        fadein = 0;
        fadeout = 0;
        onLoad = QUOTE(GVAR(VolumeControlDialog) = _this;);
        onunLoad = QUOTE(GVAR(VolumeControlDialog) = _this;);

        class controls {
            class RscSlider_1900: RscXSliderH {
                idc = 1900;
                x = 0.378232 * safezoneW + safezoneX;
                y = 0.706242 * safezoneH + safezoneY;
                w = 0.25695 * safezoneW;
                h = 0.03 * safezoneH;
            };
            /*class RscText_1000: RscText {
                idc = 1000;
                text = "Shout";
                x = 0.636093 * safezoneW + safezoneX;
                y = 0.692493 * safezoneH + safezoneY;
                w = 0.0458419 * safezoneW;
                h = 0.0549979 * safezoneH;
            };
            class RscText_1001: RscText {
                idc = 1001;
                text = "Whisper";
                x = 0.328093 * safezoneW + safezoneX;
                y = 0.692493 * safezoneH + safezoneY;
                w = 0.0458419 * safezoneW;
                h = 0.0549979 * safezoneH;
            };
            class RscText_1002: RscText {
                idc = 1002;
                text = "Normal";
                x = 0.478512 * safezoneW + safezoneX;
                y = 0.719992 * safezoneH + safezoneY;
                w = 0.0458419 * safezoneW;
                h = 0.0549979 * safezoneH;
            };*/
        };
    };

    class GVAR(vehicleInfo) {
        idd = -1;
        movingEnable = 1;
        duration = 9999999;
        fadein = 0;
        fadeout = 0;

        class controls {
            class VehicleInfoControlsGroup: RscControlsGroupNoScrollbars {
                idc = -1;
                x = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_X', profileNamespace getVariable ['IGUI_GRID_VEHICLE_X', safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40)]]";
                y = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_Y', 4.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (profileNamespace getVariable ['IGUI_GRID_VEHICLE_Y', safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)])]";
                w = "10 * (((safezoneW / safezoneH) min 1.2) / 40)";
                onLoad = "uiNamespace setVariable ['ACRE_VehicleInfo', _this select 0];";

                class Controls {
                    class VehicleInfoBackground: RscText {
                        idc = 1;
                        x = 0;
                        y = 0;
                        w = "10 * (((safezoneW / safezoneH) min 1.2) / 40)";
                        colorBackground[] = {
                            "profileNamespace getVariable ['IGUI_BCG_RGB_R', 0]",
                            "profileNamespace getVariable ['IGUI_BCG_RGB_G', 1]",
                            "profileNamespace getVariable ['IGUI_BCG_RGB_B', 1]",
                            "profileNamespace getVariable ['IGUI_BCG_RGB_A', 0.8]"
                        };
                    };
                    class VehicleInfoText: RscStructuredText {
                        idc = 2;
                        x = 0;
                        y = 0;
                        w = "9.8 * (((safezoneW / safezoneH) min 1.2) / 40)";
                    };
                };
            };
        };
    };
};
