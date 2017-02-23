class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_Actions {
            class ACE_MainActions {
                class ACRE_InfantryPhone {
                    displayName = CSTRING(infantryPhone);
                    condition = QUOTE(_player call FUNC(checkInfantryPhoneAvailability));
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    statement = "true";
                    insertChildren = QUOTE(_this call FUNC(infantryPhoneChildrenActions));
                    priority = 0.1;
                    icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
                 };
             };
         };
    };

    class Air;
    class LandVehicle;
    class Ship;
    class Car: LandVehicle {
        acre_hasIntercom = false;
    };
    class Car_F: Car {};
    class Wheeled_APC_F: Car_F {
        acre_hasIntercom = true;
    };

    class Tank: LandVehicle {
        acre_hasIntercom = true;
        acre_hasInfantryPhone = true;
    };
    class Tank_F;
    class MBT_01_base_F: Tank_F {
        acre_infantryPhonePosition[] = {1.35, -4.4, -1};
    };
    class MBT_01_arty_base_F: MBT_01_base_F {
        acre_infantryPhonePosition[] = {1.35, -4.86, -1.4};
    };
    class MBT_01_mlrs_base_F: MBT_01_base_F {
        acre_infantryPhonePosition[] = {1.35, -4.43, -0.33};
    };
    class APC_Tracked_01_base_F: Tank_F {
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
    };
    class B_APC_Tracked_01_base_F;
    class B_APC_Tracked_01_AA_F: B_APC_Tracked_01_base_F {
        acre_infantryPhonePosition[] = {-1.1, -4.85, -1.14};
    };
    class MBT_02_base_F: Tank_F {
        acre_infantryPhonePosition[] = {1.38, -4.77, -1.1};
    };
    class MBT_02_arty_base_F: MBT_02_base_F {
        acre_infantryPhonePosition[] = {1.4, -5.4, -1.65};
    };
    class APC_Tracked_02_base_F: Tank_F {
        acre_infantryPhonePosition[] = {0.98, -4.9, -0.79};
    };
    class MBT_03_base_F: Tank_F {
        acre_infantryPhonePosition[] = {1.53, -5.67, -1.29};
    };
    class APC_Tracked_03_base_F: Tank_F {
        acre_infantryPhonePosition[] = {1.1, -3.87, -0.78};
    };

    class Helicopter: Air {
        acre_hasIntercom = true;
    };

    class Plane: Air {
        acre_hasIntercom = true;
    };

    class MRAP_02_base_F: Car_F {
        acre_hasIntercom = true;
    };

    class Ship_F: Ship {
        acre_hasIntercom = false;
    };

    class Boat_F: Ship_F {};
    class SDV_01_base_F: Boat_F {
        acre_hasIntercom = true;
    };
};
