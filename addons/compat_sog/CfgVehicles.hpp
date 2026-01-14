class CfgVehicles {
    class APC_Tracked_01_base_F;
    class vn_armor_m113_base: APC_Tracked_01_base_F {
        class ACRE {
            class attenuation {
                forceSoundAttenuation = 1;
                class Compartment1 {
                    Compartment1 = 0;
                    Compartment2 = 0.6;
                };
                class Compartment2 {
                    Compartment1 = 0.6;
                    Compartment2 = 0;
                };
            };
            class attenuationTurnedOut {
                class Compartment1 {
                    Compartment1 = 0.3;
                    Compartment2 = 0;
                };
                class Compartment2 {
                    Compartment1 = 0;
                    Compartment2 = 0;
                };
            };
        };
    };

    class vn_armor_tank_base;
    class vn_armor_m48_base: vn_armor_tank_base {
        class ACRE {
            class attenuation {
                forceSoundAttenuation = 1;
                class Compartment1 {
                    Compartment1 = 0;
                    Compartment2 = 0.8;
                };
                class Compartment2 {
                    Compartment1 = 0.8;
                    Compartment2 = 0;
                };
            };
            class attenuationTurnedOut {
                class Compartment1 {
                    Compartment1 = 0;
                    Compartment2 = 0;
                };
                class Compartment2 {
                    Compartment1 = 0;
                    Compartment2 = 0;
                };
            };
        };
    };

    class vn_wheeled_truck_base;
    class vn_wheeled_m54_base: vn_wheeled_truck_base {
        class AcreRacks {
            class Rack_1 {
                allowedPositions[] = {"driver", {"ffv", {0}}};
            };
        };
    };

    class vn_wheeled_car_base;
    class vn_wheeled_m151_base: vn_wheeled_car_base {
        class AcreRacks {
            class Rack_1 {
                allowedPositions[] = {"driver", {"ffv", {0}}, "external"};
            };
        };
    };
    // Armored M151
    class vn_wheeled_m151_mg_04_base: vn_wheeled_m151_base {
        class AcreRacks: AcreRacks {
            class Rack_1: Rack_1 {
                allowedPositions[] = {"driver", {"cargo", 0}};
            };
        };
    };
};
