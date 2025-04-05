class CfgVehicles {
    // Cars
    class rhsusf_hmmwe_base;
    class rhsusf_m998_w_2dr: rhsusf_hmmwe_base {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"turret", {2}}};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };

        attenuationEffectType = "SemiOpenCarAttenuation";
    };

    class rhsusf_m998_w_2dr_halftop: rhsusf_m998_w_2dr {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhsusf_m998_w_2dr_fulltop: rhsusf_m998_w_2dr_halftop {
        attenuationEffectType = "SemiOpenCarAttenuation";
    };

    class rhsusf_m998_w_4dr;
    class rhsusf_m998_w_4dr_halftop: rhsusf_m998_w_4dr {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhsusf_m998_w_4dr_fulltop: rhsusf_m998_w_4dr_halftop {
        attenuationEffectType = "SemiOpenCarAttenuation";
    };

    class rhsusf_m1025_w: rhsusf_m998_w_4dr_fulltop {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"turret", {0}}};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };

        attenuationEffectType = "RHS_CarAttenuation";
    };

    class rhsusf_m1025_w_m2: rhsusf_m1025_w {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"turret", {1}}};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhsusf_m966_w: rhsusf_m1025_w {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"turret", {1}}};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };
    };

    class MRAP_01_base_F;
    class rhsusf_m1151_base: MRAP_01_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"inside"};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"inside"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhsusf_m1151_GPK_base: rhsusf_m1151_base {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"inside"};
                disabledPositions[] = {"gunner"};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"inside"};
                disabledPositions[] = {"gunner"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhsusf_m1152_base;
    class rhsusf_m1152_sicps_base: rhsusf_m1152_base {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"inside"};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"inside"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
            class Rack_3: Rack_2 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
            };
        };
    };

    class rhsusf_mrzr_base: MRAP_01_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"turret", {0}}};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhsusf_M1165A1_GMV_SAG2_base: rhsusf_m1151_base {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", "all"}, {"turret", {1}}};
                disabledPositions[] = {"gunner"};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"cargo", "all"}, {"turret", {1}}};
                disabledPositions[] = {"gunner"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    // MRAPs
    class Truck_01_base_F;
    class rhsusf_caiman_base: Truck_01_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}};
                disabledPositions[] = {};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"cargo", 0}};
                disabledPositions[] = {};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        attenuationEffectType = "RHS_CarAttenuation";
    };

    class rhsusf_caiman_GPK_base;
    class rhsusf_M1220_M153_M2_usarmy_d: rhsusf_caiman_GPK_base {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", "gunner"};
                disabledPositions[] = {};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner"};
                disabledPositions[] = {};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhsusf_MATV_base: MRAP_01_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"turret", {0}, {1}}};
                disabledPositions[] = {"gunner"};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"turret", {0}, {1}}};
                disabledPositions[] = {"gunner"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    class rhsusf_MATV_armed_base;
    class rhsusf_MATV_CROWS_base: rhsusf_MATV_armed_base {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dashUpper);
                shortName = ECSTRING(sys_rack,dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", "gunner", {"turret", {1}}};
                disabledPositions[] = {};
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = ECSTRING(sys_rack,dashLower);
                shortName = ECSTRING(sys_rack,dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner", {"turret", {1}}};
                disabledPositions[] = {};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    // Trucks
    class rhsusf_himars_base: Truck_01_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"inside"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };

        attenuationEffectType = "RHS_CarAttenuation";
    };

    class rhsusf_M977A4_usarmy_wd;
    class rhsusf_M977A4_BKIT_usarmy_wd: rhsusf_M977A4_usarmy_wd {
        attenuationEffectType = "MrapAttenuation";
    };
    class rhsusf_M977A4_BKIT_M2_usarmy_wd: rhsusf_M977A4_usarmy_wd {
        attenuationEffectType = "MrapAttenuation";
    };
    class rhsusf_M978A4_BKIT_usarmy_wd: rhsusf_M977A4_usarmy_wd {
        attenuationEffectType = "MrapAttenuation";
    };

    // AFVs
    class Wheeled_APC_F;
    class rhsusf_stryker_base: Wheeled_APC_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"turret", {1}, {2}, {3}, {4}}};
                masterPositions[] = {"gunner"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"inside"};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };
    };

    class rhsusf_stryker_m1126_m2_base;
    class rhsusf_stryker_m1134_base: rhsusf_stryker_m1126_m2_base {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"inside"};
                limitedPositions[] = {};
                masterPositions[] = {{"turret", {1}}};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
        };
    };

    class APC_Tracked_03_base_F;
    class RHS_M2A2_Base: APC_Tracked_03_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"commander"};
                numLimitedPositions = 1;
                connectedByDefault = 1;
            };
            class Intercom_2: Intercom_1 {
                displayName = ECSTRING(sys_intercom,passengerIntercom);
                shortName = ECSTRING(sys_intercom,shortPassengerIntercom);
                allowedPositions[] = {"inside"};
                limitedPositions[] = {};
                numLimitedPositions = 0;
                connectedByDefault = 0;
            };
        };

        acre_hasInfantryPhone = 0;
    };

    class APC_Tracked_02_base_F;
    class rhsusf_m113tank_base: APC_Tracked_02_base_F {
        acre_hasInfantryPhone = 0;
    };

    class MBT_01_base_F;
    class rhsusf_m1a1tank_base: MBT_01_base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"inside"};
                limitedPositions[] = {};
                masterPositions[] = {"commander"};
                numLimitedPositions = 0;
                connectedByDefault = 1;
            };
        };

        acre_infantryPhonePosition[] = {1.53, -4.87, -0.04};
    };

    // Aircraft
    class Heli_Transport_01_base_F;
    class RHS_UH60_Base: Heli_Transport_01_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot"};
                mountedRadio = "ACRE_PRC117F";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dash2);
                shortName = ECSTRING(sys_rack,dashShort);
            };
        };

        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}, {"ffv", "all"}};
                masterPositions[] = {"driver", "copilot"};
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

    class Heli_light_03_base_F;
    class RHS_UH1_Base: Heli_light_03_base_F {
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

    class Heli_Transport_02_base_F;
    class RHS_CH_47F_base: Heli_Transport_02_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot"};
                mountedRadio = "ACRE_PRC117F";
            };
            class Rack_2: Rack_1 {
                displayName = ECSTRING(sys_rack,dash2);
                shortName = ECSTRING(sys_rack,dashShort);
            };
        };
    };

    class Helicopter_Base_H;
    class rhsusf_CH53E_USMC: Helicopter_Base_H {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew"};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot", "gunner"};
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
    class RHS_C130J_Base: Plane_Base_F {
        class AcreIntercoms {
            class Intercom_1 {
                displayName = ECSTRING(sys_intercom,crewIntercom);
                shortName = ECSTRING(sys_intercom,shortCrewIntercom);
                allowedPositions[] = {"crew", {"cargo", 0}};
                limitedPositions[] = {{"cargo", "all"}};
                masterPositions[] = {"driver", "copilot", {"cargo", 0}};
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

    // Boats
    class RHS_Ship;
    class rhsusf_mkvsoc: RHS_Ship {
        class AcreRacks {
            class Rack_1 {
                displayName = ECSTRING(sys_rack,dash);
                shortName = ECSTRING(sys_rack,dash);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "commander", {"turret", {5}}};
                mountedRadio = "ACRE_PRC117F";
            };
        };
    };
};
