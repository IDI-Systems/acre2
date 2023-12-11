class CfgVehicles {
    // Vehicle rack vehicle definitions
    class ACRE_BaseRack;
    class ACRE_VRC64 : ACRE_BaseRack {
        displayName = "AN/VRC-64";
    };
    RADIO_ID_LIST(ACRE_VRC64)

    class ACRE_VRC110 : ACRE_BaseRack {
        displayName = "AN/VRC-110";
    };
    RADIO_ID_LIST(ACRE_VRC110)

    class ACRE_VRC103 : ACRE_BaseRack {
        displayName = "AN/VRC-103";
    };
    RADIO_ID_LIST(ACRE_VRC103)

    class ACRE_VRC111 : ACRE_BaseRack {
        displayName = "AN/VRC-111";
    };
    RADIO_ID_LIST(ACRE_VRC111)

    class ACRE_SEM90 : ACRE_BaseRack {
        displayName = "SEM90";
    };
    RADIO_ID_LIST(ACRE_SEM90)

    class ACRE_WS19 : ACRE_BaseRack {
        displayName = "Wireless Set No. 19";
    };
    RADIO_ID_LIST(ACRE_WS19)

    // Define which vehicles have racks.
    class All {
        class AcreRacks {};
    };

    class Boat_F;
    class Boat_Armed_01_base_F : Boat_F {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dash); // If you have multiple racks a text label helps identify the particular rack.
                shortName = CSTRING(dash);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    class Car_F;
    class MRAP_01_base_F : Car_F {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dashUpper); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = CSTRING(dashLower); // If you have multiple racks a text label helps identify the particular rack.
                shortName = CSTRING(dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"cargo", 0}};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    class MRAP_02_base_F: Car_F {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dashUpper); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = CSTRING(dashLower); // If you have multiple racks a text label helps identify the particular rack.
                shortName = CSTRING(dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"cargo", 0}};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    class MRAP_03_base_F: Car_F {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dashUpper); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashUpperShort);
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}, "commander"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                isRadioRemovable = 1;
                intercom[] = {"intercom_1"};
            };
            class Rack_2 {
                displayName = CSTRING(dashLower); // If you have multiple racks a text label helps identify the particular rack.
                shortName = CSTRING(dashLowerShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"cargo", 0}, "commander"};
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    class Helicopter;
    class Helicopter_Base_F: Helicopter {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dash); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "gunner", "copilot"}; // Attack helicopters have "gunner" copilots usually
                mountedRadio = "ACRE_PRC117F";
            };

            class Rack_2: Rack_1 {
                displayName = CSTRING(dash2);
                shortName = CSTRING(dashShort);
            };
        };
    };

    class ParachuteBase: Helicopter {
        class AcreRacks {};
    };

    class VTOL_01_base_F;
    class VTOL_01_unarmed_base_F: VTOL_01_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dashUpper); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashUpperShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot", {"turret", {1}, {2}}};
                mountedRadio = "ACRE_PRC117F";
            };

            class Rack_2: Rack_1 {
                displayName = CSTRING(dashLower); // If you have multiple racks a text label helps identify the particular rack.
                shortName = CSTRING(dashLowerShort);
            };
        };
    };

    class Plane;
    class Plane_Base_F: Plane {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dash); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                mountedRadio = "ACRE_PRC117F";
            };

            class Rack_2: Rack_1 {
                displayName = CSTRING(dash2); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashShort);
            };
        };
    };

    class Plane_Civil_01_base_F: Plane_Base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dash); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                mountedRadio = "ACRE_PRC117F";
            };
        };
    };

    class Tank;
    class Tank_F: Tank {
         class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dash); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "commander", "gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };

    //class Car_F; // defined earlier.
    class Wheeled_APC_F: Car_F {
         class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(dash); // Name is displayed in the interaction menu.
                shortName = CSTRING(dashShort);
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "commander", "gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                mountedRadio = "ACRE_PRC117F";
                intercom[] = {"intercom_1"};
            };
        };
    };
};
