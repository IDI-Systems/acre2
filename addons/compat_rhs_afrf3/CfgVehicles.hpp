class CfgVehicles {
    // Cars
    class MRAP_02_base_F;
    class rhs_tigr_base: MRAP_02_base_F {
        class AcreRacks {};
    };

    class rhs_tigr_vdv;
    class rhs_tigr_sts_vdv: rhs_tigr_vdv {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}};
                disabledPositions[] = {};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhs_tigr_m_vdv: rhs_tigr_vdv {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 1}};
                disabledPositions[] = {};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };
    };

    // Trucks
    class O_Truck_03_repair_F;
    class rhs_typhoon_base: O_Truck_03_repair_F {
        attenuationEffectType = "RHS_CarAttenuation";
    };

    class OTR21_Base;
    class rhs_9k79: OTR21_Base {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dash);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"inside"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        attenuationEffectType = "RHS_CarAttenuation";
    };

    // AFVs
    class Wheeled_APC_F;
    class rhs_btr_base: Wheeled_APC_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner", {"turret", {1}}};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"turret", {10}}};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {{"turret", {1}, {10}}};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };
    };

    class rhs_btr70_msv;
    class rhs_btr80_msv: rhs_btr70_msv {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"turret", {11}}};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {{"turret", {1}, {11}}};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };
    };

    class Tank_F;
    class rhs_bmp1tank_base: Tank_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner", "commander", {"turret", {1}}};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"turret", {1}}};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander", {"turret", {1}}};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class rhs_bmp1_vdv;
    class rhs_bmp2e_vdv: rhs_bmp1_vdv {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner", {"turret", {1}}};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"turret", {0, 0}}};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander", {"turret", {1}}};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };
    };

    class rhs_prp3_vdv: rhs_bmp1_vdv {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner", "commander", {"turret", {0}, {1}}};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"turret", {0}, {1}}};
                limitedPositions[] = {};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };
    };

    class rhs_bmp3tank_base: Tank_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"turret", {1}, {2}}};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class rhs_bmd_base: Tank_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner", {"turret", {1}}};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander", {"turret", {1}}};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class rhs_a3spruttank_base;
    class rhs_bmd4_vdv: rhs_a3spruttank_base {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner", {"turret", {0, 0}}};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"turret", {0, 0}}};
                limitedPositions[] = {};
                masterPositions[] = {{"turret", {0, 0}}};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class rhs_sprut_vdv: rhs_a3spruttank_base {
        acre_hasInfantryPhone = 0;
    };

    class rhs_a3t72tank_base: Tank_F {
        acre_hasInfantryPhone = 0;
    };

    class rhs_tank_base;
    class rhs_t80b: rhs_tank_base {
        acre_hasInfantryPhone = 0;
    };

    class rhs_t14_base: Tank_F {
        acre_infantryPhonePosition[] = {-1.39, -5.35, -1.07};
    };

    class APC_Tracked_02_base_F;
    class rhs_zsutank_base: APC_Tracked_02_base_F {
        acre_hasInfantryPhone = 0;
    };

    // Aircraft
    class Heli_Light_02_base_F;
    class RHS_Mi8_base: Heli_Light_02_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"driver"};
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

    class Heli_Attack_02_base_F;
    class RHS_Mi24_base: Heli_Attack_02_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"driver"};
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

    class RHS_Ka52_base: Heli_Attack_02_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                masterPositions[] = {"driver"};
                connectedByDefault = 1;
            };
        };
    };
};
