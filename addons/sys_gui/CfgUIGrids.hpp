class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    grid_ACRE_vehicleInfo[] = {
                        {
                            VEHICLE_INFO_DEFAULT_X,
                            VEHICLE_INFO_DEFAULT_Y,
                            VEHICLE_INFO_DEFAULT_W,
                            VEHICLE_INFO_DEFAULT_H
                        },
                        IGUI_GRID_VEHICLE_W,
                        IGUI_GRID_VEHICLE_H
                    };
                };
            };
        };

        class Variables {
            class grid_ACRE_vehicleInfo {
                displayName = CSTRING(VehicleInfoGrid);
                description = CSTRING(VehicleInfoGridDesc);
                preview = QPATHTOF(data\ui\IGUI_vehicleInfo_preview_ca.paa);
                saveToProfile[] = {0, 1};
                canResize = 0;
            };
        };
    };
};
