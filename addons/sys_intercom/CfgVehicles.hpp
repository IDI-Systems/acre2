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

    class Car_F;
    class Wheeled_APC_F: Car_F {
        acre_hasIntercom = 1;
    };

    class MRAP_02_base_F: Car_F {
        acre_hasIntercom = 1;
    };

    class LandVehicle;
    class Tank: LandVehicle {
        acre_hasIntercom = 1;
        acre_hasInfantryPhone = 1;
        acre_hasPassengerIntercom = 1;
    };

    // BLUFOR
    class MBT_01_base_F;
    class B_MBT_01_base_F: MBT_01_base_F {};

    class B_MBT_01_cannon_F: B_MBT_01_base_F {
        acre_infantryPhonePosition[] = {1.35, -4.4, -1};
        acre_passengerIntercomConnections = 2;
    };

    class MBT_01_arty_base_F: MBT_01_base_F {};
    class B_MBT_01_arty_base_F: MBT_01_arty_base_F {};

    class B_MBT_01_arty_F: B_MBT_01_arty_base_F {
        acre_infantryPhonePosition[] = {1.35, -4.86, -1.4};
    };

    class MBT_01_mlrs_base_F: MBT_01_base_F {};
    class B_MBT_01_mlrs_base_F: MBT_01_mlrs_base_F {};

    class B_MBT_01_mlrs_F: B_MBT_01_mlrs_base_F {
        acre_infantryPhonePosition[] = {1.35, -4.43, -0.33};
    };

    class B_APC_Tracked_01_base_F;
    class B_APC_Tracked_01_rcws_F: B_APC_Tracked_01_base_F {
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
    };

    class B_APC_Tracked_01_AA_F: B_APC_Tracked_01_base_F {
        acre_infantryPhonePosition[] = {-1.1, -4.85, -1.14};
    };

    class B_APC_Tracked_01_CRV_F: B_APC_Tracked_01_base_F {
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
    };

    // OPFOR
    class MBT_02_base_F;
    class O_MBT_02_base_F: MBT_02_base_F {};

    class O_MBT_02_cannon_F: O_MBT_02_base_F {
        acre_infantryPhonePosition[] = {1.38, -4.77, -1.1};
    };

    class MBT_02_arty_base_F: MBT_02_base_F {};
    class O_MBT_02_arty_base_F: MBT_02_arty_base_F {};

    class O_MBT_02_arty_F: O_MBT_02_arty_base_F {
        acre_infantryPhonePosition[] = {1.4, -5.4, -1.65};
    };

    class O_APC_Tracked_02_base_F;
    class O_APC_Tracked_02_cannon_F: O_APC_Tracked_02_base_F {
        acre_infantryPhonePosition[] = {0.98, -4.9, -0.79};
    };

    class O_APC_Tracked_02_AA_F: O_APC_Tracked_02_base_F {
        acre_infantryPhonePosition[] = {0.98, -4.9, -0.79};
    };

    // INDEPENDENT
    class I_MBT_03_base_F;
    class I_MBT_03_cannon_F: I_MBT_03_base_F {
        acre_infantryPhonePosition[] = {1.53, -5.67, -1.29};
    };

    class I_APC_tracked_03_base_F;
    class I_APC_tracked_03_cannon_F: I_APC_tracked_03_base_F {
        acre_infantryPhonePosition[] = {1.1, -3.87, -0.78};
    };

    class Air;
    class Helicopter: Air {
        acre_hasIntercom = 1;
    };

    class Plane: Air {
        acre_hasIntercom = 1;
    };

    class Boat_F;
    class SDV_01_base_F: Boat_F {
        acre_hasIntercom = 1;
    };
};
