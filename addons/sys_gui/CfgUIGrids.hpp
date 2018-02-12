class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    grid_ACRE_vehicleInfo[] = {
                        {
                            "0 * (((safezoneW / safezoneH) min 1.2) / 40) + (profileNamespace getVariable ['IGUI_GRID_VEHICLE_X', safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40)])",
                            "4.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (profileNamespace getVariable ['IGUI_GRID_VEHICLE_Y', safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)])",
                            "profileNamespace getVariable ['IGUI_GRID_VEHICLE_Y', 10 * (((safezoneW / safezoneH) min 1.2) / 40)]",
                            "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"
                        },
                        "((safezoneW / safezoneH) min 1.2) / 40",
                        "(((safezoneW / safezoneH) min 1.2) / 1.2) / 25"
                    };
                };
            };
        };

        class Variables {
            class grid_ACRE_vehicleInfo {
                displayName = "ACRE2 - Vehicle Info";
                description = "Status on available Intercoms and Racks in the vehicle.";
                preview = "#(argb,8,8,3)color(0.2,0.2,0.2,0.5)"; //TODO Image
                saveToProfile[] = {0, 1, 2, 3};
                canResize = 0;
            };
        };
    };
};
