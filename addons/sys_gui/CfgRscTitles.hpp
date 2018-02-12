#include "MyDialogDefines.hpp"

class RscXSliderH;
class RscText;
class RscStructuredText;
class RscControlsGroupNoScrollbars;

class RscTitles {
    class GVAR(VolumeControlDialog)  {
        idd = -1;
        movingEnable = 1;
        enableSimulation = 1;
        enableDisplay = 1;

        onLoad = QUOTE(GVAR(VolumeControlDialog) = _this;);
        onunLoad = QUOTE(GVAR(VolumeControlDialog) = _this;);

        duration = 9999;
        fadein = 0;
        fadeout = 0;

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
        enableSimulation = 1;
        enableDisplay = 1;
        duration = 9999999;
        fadein = 0;
        fadeout = 0;

        class controls {
            class VehicleInfoControlsGroup: RscControlsGroupNoScrollbars {
                idc = -1;
                x = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_X', 0 * (((safezoneW / safezoneH) min 1.2) / 40) + (profileNamespace getVariable ['IGUI_GRID_VEHICLE_X', safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40)])]";
                y = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_Y', 4.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (profileNamespace getVariable ['IGUI_GRID_VEHICLE_Y', safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)])]";
                w = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_W', 10 * (((safezoneW / safezoneH) min 1.2) / 40)]";
                h = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_H', 1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)]";

                class Controls {
                    class VehicleInfoBackground: RscText {
                        idc = -1;
                        x = 0;
                        y = 0;
                        w = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_W', 10 * (((safezoneW / safezoneH) min 1.2) / 40)]";
                        h = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_H', 1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)]";
                        colorBackground[] = {
                            "profileNamespace getVariable ['IGUI_BCG_RGB_R', 0]",
                            "profileNamespace getVariable ['IGUI_BCG_RGB_G', 1]",
                            "profileNamespace getVariable ['IGUI_BCG_RGB_B', 1]",
                            "profileNamespace getVariable ['IGUI_BCG_RGB_A', 0.8]"
                        };
                    };
                    class VehicleInfoText: RscStructuredText {
                        idc = -1;
                        x = 0;
                        y = 0;
                        w = "0.98 * (profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_W', ((safezoneW / safezoneH) min 1.2) / 40])";
                        h = "0.8 * (profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_H', (((safezoneW / safezoneH) min 1.2) / 1.2) / 25])";
                        onLoad = "uiNamespace setVariable ['ACRE_VehicleInfo', _this select 0];";
                    };
                };
            };
        };
    };
};
