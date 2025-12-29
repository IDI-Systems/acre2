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
                    icon = ICON_RADIO_CALL;
                 };
             };
         };
    };

    class Car_F;
    class Wheeled_APC_F: Car_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                masterPositions[] = {"commander"};
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
        acre_infantryPhoneIntercom[] = {"all"};
        acre_infantryPhoneControlActions[] = {"intercom_1"};
        acre_eventInfantryPhone = QFUNC(noApiFunction);
    };

    class LandVehicle;
    class Tank: LandVehicle {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 1;
        acre_infantryPhoneIntercom[] = {"all"};
        acre_infantryPhoneControlActions[] = {"intercom_1"};
        acre_eventInfantryPhone = QFUNC(noApiFunction);
    };

    // BLUFOR
    class B_MBT_01_base_F;
    class B_MBT_01_cannon_F: B_MBT_01_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        acre_infantryPhonePosition[] = {1.35, -4.4, -1};
    };

    class B_MBT_01_arty_base_F;
    class B_MBT_01_arty_F: B_MBT_01_arty_base_F {
        acre_infantryPhonePosition[] = {1.35, -4.86, -1.4};
    };

    class B_MBT_01_mlrs_base_F;
    class B_MBT_01_mlrs_F: B_MBT_01_mlrs_base_F {
        acre_infantryPhonePosition[] = {1.35, -4.43, -0.33};
    };

    class B_APC_Tracked_01_base_F;
    class B_APC_Tracked_01_rcws_F: B_APC_Tracked_01_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
    };

    class B_APC_Tracked_01_AA_F: B_APC_Tracked_01_base_F {
        acre_infantryPhonePosition[] = {-1.1, -4.85, -1.14};
    };

    class B_APC_Tracked_01_CRV_F: B_APC_Tracked_01_base_F {
        acre_infantryPhonePosition[] = {-1.1, -4.86, -0.82};
    };

    class B_APC_Wheeled_01_base_F;
    class B_APC_Wheeled_01_cannon_F :B_APC_Wheeled_01_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        acre_hasInfantryPhone = 1;
        acre_infantryPhonePosition[] = {-0.70, -4.61, -1.00};
    };

    class AFV_Wheeled_01_base_F: Wheeled_APC_F {
        acre_hasInfantryPhone = 1;
        acre_infantryPhonePosition[] = {-1.24, -4.35, -0.81};
    };

    class AFV_Wheeled_01_up_base_F: AFV_Wheeled_01_base_F {
        acre_infantryPhonePosition[] = {-1.24, -4.35, -0.92};
    };

    // OPFOR
    class O_MBT_02_base_F;
    class O_MBT_02_cannon_F: O_MBT_02_base_F {
        acre_infantryPhonePosition[] = {1.38, -4.77, -1.1};
    };

    class O_MBT_02_railgun_base_F;
    class O_MBT_02_railgun_F: O_MBT_02_railgun_base_F {
        acre_infantryPhonePosition[] = {1.38, -4.77, -1.1};
    };

    class MBT_04_cannon_base_F;
    class O_MBT_04_cannon_F: MBT_04_cannon_base_F {
        acre_infantryPhonePosition[] = {-1.47, -5.68, -0.82};
    };

    class MBT_04_command_base_F;
    class O_MBT_04_command_F: MBT_04_command_base_F {
        acre_infantryPhonePosition[] = {-1.47, -5.68, -1.17};
    };

    class O_MBT_02_arty_base_F;
    class O_MBT_02_arty_F: O_MBT_02_arty_base_F {
        acre_infantryPhonePosition[] = {1.4, -5.4, -1.65};
    };

    class O_APC_Tracked_02_base_F;
    class O_APC_Tracked_02_cannon_F: O_APC_Tracked_02_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        acre_infantryPhonePosition[] = {0.98, -4.9, -0.79};
    };

    class O_APC_Tracked_02_AA_F: O_APC_Tracked_02_base_F {
        acre_infantryPhonePosition[] = {0.98, -4.9, -0.79};
    };

    class APC_Wheeled_02_base_F;
    class APC_Wheeled_02_base_v2_F: APC_Wheeled_02_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        acre_hasInfantryPhone = 1;
        acre_infantryPhonePosition[] = {1.10, -4.45, -0.65};
    };

    // INDEPENDENT
    class I_MBT_03_base_F;
    class I_MBT_03_cannon_F: I_MBT_03_base_F {
        acre_infantryPhonePosition[] = {1.53, -5.67, -1.29};
    };

    class I_APC_tracked_03_base_F;
    class I_APC_tracked_03_cannon_F: I_APC_tracked_03_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        acre_infantryPhonePosition[] = {1.1, -3.87, -0.78};
    };

    class APC_Wheeled_03_base_F;
    class I_APC_Wheeled_03_base_F: APC_Wheeled_03_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        acre_hasInfantryPhone = 1;
        acre_infantryPhonePosition[] = {-0.70, -4.51, -0.67};
    };

    class LT_01_base_F;
    class LT_01_AA_base_F: LT_01_base_F {};
    class I_LT_01_AA_F: LT_01_AA_base_F {
        acre_infantryPhonePosition[] = {-1.10, -1.66, -0.83};
    };

    class LT_01_AT_base_F: LT_01_base_F {};
    class I_LT_01_AT_F: LT_01_AT_base_F {
        acre_infantryPhonePosition[] = {-1.10, -1.66, -0.83};
    };

    class LT_01_cannon_base_F: LT_01_base_F {};
    class I_LT_01_cannon_F: LT_01_cannon_base_F {
        acre_infantryPhonePosition[] = {-1.10, -1.90, -0.78};
    };

    class LT_01_scout_base_F: LT_01_base_F {};
    class I_LT_01_scout_F: LT_01_scout_base_F {
        acre_infantryPhonePosition[] = {-1.10, -1.90, -0.78};
    };

    class Air;
    class Helicopter: Air {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                masterPositions[] = {"driver"};
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 1;
        acre_infantryPhoneDisableRinging = 1;
        acre_infantryPhoneIntercom[] = {"all"};
        acre_infantryPhoneControlActions[] = {"intercom_1"};
    };

    class ParachuteBase: Helicopter {
        class AcreIntercoms {};
        acre_hasInfantryPhone = 0;
    };

    // BLUFOR
    class Heli_Light_01_unarmed_base_F;
    class B_Heli_Light_01_F: Heli_Light_01_unarmed_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Helicopter_Base_H;
    class Heli_Transport_03_base_F: Helicopter_Base_H {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}, {"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Heli_Transport_01_base_F: Helicopter_Base_H {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    // OPFOR
    class Heli_Light_02_base_F: Helicopter_Base_H {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Helicopter_Base_F;
    class Heli_Attack_02_base_F: Helicopter_Base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Heli_Transport_04_base_F;
    class O_Heli_Transport_04_medevac_F: Heli_Transport_04_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class O_Heli_Transport_04_F: Heli_Transport_04_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Heli_Light_01_civil_base_F : Heli_Light_01_unarmed_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    // INDEPENDENT
    class Heli_Transport_02_base_F: Helicopter_Base_H {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}, {"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Heli_light_03_base_F: Helicopter_Base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Plane: Air {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                masterPositions[] = {"driver"};
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 1;
        acre_infantryPhoneDisableRinging = 1;
        acre_infantryPhoneIntercom[] = {"all"};
        acre_infantryPhoneControlActions[] = {"intercom_1"};
    };

    class VTOL_01_unarmed_base_F;
    class VTOL_01_infantry_base_F: VTOL_01_unarmed_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                disabledPositions[] = {{"turret", {1}, {2}}};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"},{"turret", "all"},{"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class VTOL_01_vehicle_base_F: VTOL_01_unarmed_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"turret", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class VTOL_02_base_F;
    class VTOL_02_infantry_base_F: VTOL_02_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"turret", "all"}, {"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Plane_Base_F;
    class Plane_Civil_01_base_F : Plane_Base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_AIRCREW;
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = CSTRING(passengerIntercom);
                shortName = CSTRING(shortPassengerIntercom);
                icon = ICON_INTERCOM_PAX;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Boat_F;
    class SDV_01_base_F: Boat_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = CSTRING(crewIntercom);
                shortName = CSTRING(shortCrewIntercom);
                icon = ICON_INTERCOM_CREW;
                allowedPositions[] = {"crew", {"cargo", "all"}};
                masterPositions[] = {"driver"};
                connectedByDefault = 1;
            };
        };
    };
};
