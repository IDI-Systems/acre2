class CfgVehicles {
#ifdef PLATFORM_A3
    class Air;
    class LandVehicle;
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

    class Car_F : Car {
        insideSoundCoef = 0.5;
    };

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
        insideSoundCoef = 0.8;
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
            };
        };
    };

    class Truck_F;
    class Van_01_base_F: Truck_F {
        insideSoundCoef = 0.0f;
    };
    /*
    class Truck_01_base_F: Truck_F {
        class ACRE {
            class attenuation {
                class Compartment1  {
                    Compartment1 = 0.4;
                    Compartment2 = 0.4;
                    Compartment3 = 0.4;
                    Compartment4 = 0.4;
                };
                class Compartment2  {
                    Compartment1 = 0.4;
                    Compartment2 = 0.4;
                    Compartment3 = 0.4;
                    Compartment4 = 0.4;
                };
                class Compartment3  {
                    Compartment1 = 0.4;
                    Compartment2 = 0.4;
                    Compartment3 = 0.4;
                    Compartment4 = 0.4;
                };
                class Compartment4  {
                    Compartment1 = 0.4;
                    Compartment2 = 0.4;
                    Compartment3 = 0.4;
                    Compartment4 = 0.4;
                };
            };
            class CVC {
                hasCVC = false;
            };
        };
    };
    */
    class Quadbike_01_base_F: Car_F {
        insideSoundCoef = 0.0f;
    };
#endif
};
