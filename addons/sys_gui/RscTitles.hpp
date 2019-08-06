class RscTitles {
    #define VOLUME_CONTROL_POSITION \
        x = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,GVAR(volumeControl),X)',VOLUME_CONTROL_DEFAULT_X)]); \
        y = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,GVAR(volumeControl),Y)',VOLUME_CONTROL_DEFAULT_Y)]); \
        w = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,GVAR(volumeControl),W)',VOLUME_CONTROL_DEFAULT_W)]); \
        h = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,GVAR(volumeControl),H)',VOLUME_CONTROL_DEFAULT_H)]); \

    class GVAR(VolumeControl) {
        idd = -1;
        fadeIn = 0;
        fadeOut = 0;
        duration = 999999;
        movingEnable = 0;
        class controls {
            class Background: RscText {
                idc = -1;
                colorBackground[] = {1, 1, 1, 0.2};
                VOLUME_CONTROL_POSITION
            };
            class Level: RscProgress {
                idc = -1;
                onLoad = QUOTE(with uiNamespace do {GVAR(volumeControl) = _this select 0});
                colorBar[] = {0, 0, 0, 0};
                colorFrame[] = {0, 0, 0, 0};
                texture = "#(argb,8,8,3)color(1,1,1,1)";
                VOLUME_CONTROL_POSITION
            };
        };
    };

    class GVAR(vehicleInfo) {
        idd = -1;
        fadeIn = 0;
        fadeOut = 0;
        duration = 9999999;
        movingEnable = 0;
        class controls {
            class VehicleInfoControlsGroup: RscControlsGroupNoScrollbars {
                idc = -1;
                x = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_X', profileNamespace getVariable ['IGUI_GRID_VEHICLE_X', safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40)]]";
                y = "profileNamespace getVariable ['IGUI_grid_ACRE_vehicleInfo_Y', 4.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (profileNamespace getVariable ['IGUI_GRID_VEHICLE_Y', safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)])]";
                w = "10 * (((safezoneW / safezoneH) min 1.2) / 40)";
                onLoad = "uiNamespace setVariable ['ACRE_VehicleInfo', _this select 0];";
                class controls {
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
