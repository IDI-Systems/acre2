class CfgVehicles {
    // Cars
    class Car_F;
    class uns_willys_base: Car_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", "external"};
                mountedRadio = "ACRE_PRC77";
            };
        };
    };

    // Trucks
    class Truck_F;
    class uns_P12_base: Truck_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "gunner"};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };
    };

    // AFVs
    class Wheeled_APC_F;
    class uns_xm706e1_base: Wheeled_APC_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
        };
    };

    class uns_Type63_mg_base: Wheeled_APC_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
        };
    };

    class Tank_F;
    class uns_M113_base: Tank_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "commander", "gunner"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"gunner", "commander"};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class uns_m48a3: Tank_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {};
                masterPositions[] = {"commander"};
                numLimitedPositions = 0;
                connectedByDefault = 1;
            };
        };

        acre_infantryPhonePosition[] = {0.40, -3.75, 1.13};
    };

    class uns_m551_base: Tank_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {};
                masterPositions[] = {"commander"};
                numLimitedPositions = 0;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class uns_t34_85_nva: Tank_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {};
                masterPositions[] = {"commander"};
                numLimitedPositions = 0;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class uns_pt76: Tank_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {};
                masterPositions[] = {"commander"};
                numLimitedPositions = 0;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class uns_T55_Base: Tank_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {};
                masterPositions[] = {"commander"};
                numLimitedPositions = 0;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class MBT_01_arty_base_F;
    class uns_m107_base: MBT_01_arty_base_F {
        acre_hasInfantryPhone = 0;
    };

    class uns_ZSU_base: Tank_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {"intercom_1"};
            };
        };

        acre_hasInfantryPhone = 0;
    };

    // Aircraft
    class Helicopter_Base_H;
    class uns_AH1g_base: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {};
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };
    };

    class uns_H13_base: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "gunner", {"turret", {0}}};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {};
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"turret", {0}}};
                masterPositions[] = {"driver", "gunner", {"turret", {0}}};
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class uns_UH1D_base: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {};
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"driver", "gunner"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}, {"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class uns_UH1C_M21_M200: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {};
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"driver", "gunner"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}, {"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class uns_ch34: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "copilot"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {};
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"driver", "copilot"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}, {"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class uns_ch46d: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {};
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "gunner"};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class uns_ch47_m60_usmc: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "gunner"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {};
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "gunner"};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class uns_ch53_base: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", {"turret", {0}}};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", {"turret", {0}}};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class uns_Mi8TV_base: Helicopter_Base_H {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", {"turret", {0}}};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", {"turret", {0}}};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class Plane_Base_F;
    class uns_plane: Plane_Base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "copilot", "gunner", "commander"};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                masterPositions[] = {"driver", "copilot"};
                connectedByDefault = 1;
            };
        };
    };

    class uns_plane;
    class uns_o1: uns_plane {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", {"turret", {0}}};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"driver", {"turret", {0}}};
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class uns_skymaster_base: uns_plane {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", {"turret", {0}}};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"inside"};
                masterPositions[] = {"driver", {"turret", {0}}};
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class uns_c1a: uns_plane {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "gunner"};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class uns_C130_Base: uns_plane {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander", {"turret", {1}}};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"driver", "commander", {"turret", {1}}};
                numLimitedPositions = 4;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}, {"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class uns_AC47: uns_plane {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", {"cargo", 0}};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                masterPositions[] = {"driver", {"cargo", 0}};
                connectedByDefault = 1;
            };
        };
    };

    class uns_b52h: uns_plane {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"inside"};
                mountedRadio = "ACRE_PRC77";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
            };
        };
    };

    class uns_an2: uns_plane {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"driver", "gunner"};
                numLimitedPositions = 2;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"crew", {"cargo", "all"}, {"ffv", "all"}};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    // Boats
    class uns_boat_base_turret;
    class UNS_BOATS_Base: uns_boat_base_turret {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC64";
                allowedPositions[] = {"driver", "commander"};
                mountedRadio = "ACRE_PRC77";
                intercom[] = {"intercom_1"};
            };
        };
    };
};
