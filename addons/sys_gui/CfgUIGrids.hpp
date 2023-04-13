class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    GVAR(volumeControl)[] = {
                        {
                            QUOTE(VOLUME_CONTROL_DEFAULT_X),
                            QUOTE(VOLUME_CONTROL_DEFAULT_Y),
                            QUOTE(VOLUME_CONTROL_DEFAULT_W),
                            QUOTE(VOLUME_CONTROL_DEFAULT_H)
                        },
                        QUOTE(POS_W(1)),
                        QUOTE(POS_H(1))
                    };
                    grid_ACRE_vehicleInfo[] = {
                        {
                            QUOTE(VEHICLE_INFO_DEFAULT_X),
                            QUOTE(VEHICLE_INFO_DEFAULT_Y),
                            QUOTE(VEHICLE_INFO_DEFAULT_W),
                            QUOTE(VEHICLE_INFO_DEFAULT_H)
                        },
                        QUOTE(IGUI_GRID_VEHICLE_W),
                        QUOTE(IGUI_GRID_VEHICLE_H)
                    };
                };
            };
        };
        class Variables {
            class GVAR(volumeControl) {
                displayName = CSTRING(VolumeControlGrid_DisplayName);
                description = CSTRING(VolumeControlGrid_Description);
                preview = QPATHTOF(data\ui\volume_control_preview.paa);
                saveToProfile[] = {0, 1, 2, 3};
                canResize = 1;
            };
            class grid_ACRE_vehicleInfo {
                displayName = CSTRING(VehicleInfoGrid_DisplayName);
                description = CSTRING(VehicleInfoGrid_Description);
                preview = QPATHTOF(data\ui\IGUI_vehicleInfo_preview_ca.paa);
                saveToProfile[] = {0, 1, 2, 3}; // Save W and H as well due to 1.94 bug setting W to 0
                canResize = 0;
            };
        };
    };
};
