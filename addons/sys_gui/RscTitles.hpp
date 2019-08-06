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

    #define VEHICLE_INFO_POSITION \
        x = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,grid_ACRE_vehicleInfo,X)',VEHICLE_INFO_DEFAULT_X)]); \
        y = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,grid_ACRE_vehicleInfo,Y)',VEHICLE_INFO_DEFAULT_Y)]); \
        w = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,grid_ACRE_vehicleInfo,W)',VEHICLE_INFO_DEFAULT_W)]); \
        h = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,grid_ACRE_vehicleInfo,H)',VEHICLE_INFO_DEFAULT_H)]); \

    class GVAR(vehicleInfo) {
        idd = -1;
        fadeIn = 0;
        fadeOut = 0;
        duration = 999999;
        movingEnable = 1;
        class controls {
            class VehicleInfoControlsGroup: RscControlsGroupNoScrollbars {
                idc = -1;
                onLoad = QUOTE(with uiNamespace do {ACRE_VehicleInfo = _this select 0});
                VEHICLE_INFO_POSITION
                class controls {
                    class VehicleInfoBackground: RscText {
                        idc = 1;
                        colorBackground[] = IGUI_BCG_COLOR;
                    };
                    class VehicleInfoText: RscStructuredText {
                        idc = 2;
                    };
                };
            };
        };
    };
};
