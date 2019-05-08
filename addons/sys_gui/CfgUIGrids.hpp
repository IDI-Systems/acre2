class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
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
            class grid_ACRE_vehicleInfo {
                displayName = CSTRING(VehicleInfoGrid);
                description = CSTRING(VehicleInfoGridDesc);
                preview = QPATHTOF(data\ui\IGUI_vehicleInfo_preview_ca.paa);
                saveToProfile[] = {0, 1, 2, 3};
                canResize = 0;
            };
        };
    };
};
