class CfgVehicles {
    class Air;
    class LandVehicle;
    class Ship;
    class Car : LandVehicle {
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
    class Car_F : Car {};
    class Wheeled_APC_F : Car_F {
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

    class Tank : LandVehicle {
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
                infantryPhonePosition[] = {1.42, -4.43, -1.05};
            };
        };
    };

    class Helicopter : Air {
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

    class Plane : Air {
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

    class Ship_F : Ship {
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

    class Boat_F : Ship_F {};
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
