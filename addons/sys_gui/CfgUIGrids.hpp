class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    GVAR(volumeControl)[] = {
                        {
                            VOLUME_CONTROL_DEFAULT_X,
                            VOLUME_CONTROL_DEFAULT_Y,
                            VOLUME_CONTROL_DEFAULT_W,
                            VOLUME_CONTROL_DEFAULT_H
                        },
                        POS_W(1),
                        POS_H(1)
                    };
                    grid_ACRE_vehicleInfo[] = {
                        {
                            "profileNamespace getVariable ['IGUI_GRID_VEHICLE_X', safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40)]",
                            "4.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (profileNamespace getVariable ['IGUI_GRID_VEHICLE_Y', safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)])",
                            "profileNamespace getVariable ['IGUI_GRID_VEHICLE_W', 10 * (((safezoneW / safezoneH) min 1.2) / 40)]",
                            "(((safezoneW / safezoneH) min 1.2) / 1.2) / 25"
                        },
                        "((safezoneW / safezoneH) min 1.2) / 40",
                        "(((safezoneW / safezoneH) min 1.2) / 1.2) / 25"
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
                saveToProfile[] = {0, 1};
                canResize = 0;
            };
        };
    };
};
