class CfgVehicles {
    class Air;
    class LandVehicle;
    class Ship;
    class Car: LandVehicle {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = false;
            };
        };
    };
    class Car_F: Car {};
    class Wheeled_APC_F: Car_F {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment2  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment3  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment4  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };

    class Tank: LandVehicle {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment2  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment3  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
                class Compartment4  {
                    Compartment1 = 1;
                    Compartment2 = 1;
                    Compartment3 = 1;
                    Compartment4 = 1;
                };
            };
            class CVC {
                hasCVC = true;
                hasInfantryPhone = true;
            };
        };
    };
    class Tank_F: Tank {};
    class MBT_01_base_F: Tank_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {1.35, -4.4, -1};
            };
        };
    };
    class MBT_01_arty_base_F: MBT_01_base_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {1.35, -4.86, -1.4};
            };
        };
    };
    class MBT_01_mlrs_base_F: MBT_01_base_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {1.35, -4.43, -0.33};
            };
        };
    };
    class APC_Tracked_01_base_F: Tank_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {-1.1, -4.86, -0.82};
            };
        };
    };
    class B_APC_Tracked_01_base_F: APC_Tracked_01_base_F {};
    class B_APC_Tracked_01_AA_F: B_APC_Tracked_01_base_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {-1.1, -4.85, -1.14};
            };
        };
    };
    class MBT_02_base_F: Tank_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {1.38, -4.77, -1.1};
            };
        };
    };
    class MBT_02_arty_base_F: MBT_02_base_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {1.4, -5.4, -1.65};
            };
        };
    };
    class APC_Tracked_02_base_F: Tank_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {0.98, -4.9, -0.79};
            };
        };
    };
    class MBT_03_base_F: Tank_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {1.53, -5.67, -1.29};
            };
        };
    };
    class APC_Tracked_03_base_F: Tank_F {
        class ACRE: ACRE {
            class CVC: CVC {
                infantryPhonePosition[] = {1.1, -3.87, -0.78};
            };
        };
    };

    class Helicopter: Air {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };

    class Plane: Air {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };

    class MRAP_02_base_F: Car_F {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = true;
                hasInfantryPhone = true;
            };
        };
    };

    class Ship_F: Ship {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = false;
            };
        };
    };

    class Boat_F: Ship_F {};
    class SDV_01_base_F: Boat_F {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment2  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment3  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
                class Compartment4  {
                    Compartment1 = 0;
                    Compartment2 = 0;
                    Compartment3 = 0;
                    Compartment4 = 0;
                };
            };
            class CVC {
                hasCVC = true;
            };
        };
    };
};
