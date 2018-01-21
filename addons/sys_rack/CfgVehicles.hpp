class CfgVehicles {
    // Vehicle rack vehicle definitions
    class ACRE_BaseRack;
    class ACRE_VRC64 : ACRE_BaseRack {
        displayName = "AN/VRC-64 Rack";
    };
    RADIO_ID_LIST(ACRE_VRC64);

    class ACRE_VRC110 : ACRE_BaseRack {
        displayName = "AN/VRC-110 Rack";
    };
    RADIO_ID_LIST(ACRE_VRC110)

    class ACRE_VRC103 : ACRE_BaseRack {
        displayName = "AN/VRC-103 Rack";
    };
    RADIO_ID_LIST(ACRE_VRC103)

    class ACRE_VRC111 : ACRE_BaseRack {
        displayName = "AN/VRC-111 Rack";
    };
    RADIO_ID_LIST(ACRE_VRC111)

    class ACRE_SEM90 : ACRE_BaseRack {
        displayName = "SEM90 Rack";
    };
    RADIO_ID_LIST(ACRE_SEM90)

    // Define which vehicles have racks.
    class All {
        class AcreRacks {};
    };

    class Boat_F;
    class Boat_Armed_01_base_F : Boat_F {
        class AcreRacks {
            class Rack_1 {
                displayName = "Dash"; // If you have multiple racks a text label helps identify the particular rack..
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver"};
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {};
            };
        };
    };

    class Car_F;
    class MRAP_01_base_F : Car_F {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(Dash_upper); // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabledPositions[] = {};
                defaultComponents[] = {}; // Use this to attach simple components like Antennas, they will first attempt to fill empty connectors but will overide existing connectors - ACRE_13IN_UHF_BNC
                mountedRadio = "";
                isRadioRemovable = 1;
                intercom[] = {};
            };
            class Rack_2 {
                displayName = CSTRING(Dash_lower); // If you have multiple racks a text label helps identify the particular rack..
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"cargo", 0}};
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {};
            };
        };
    };

    class MRAP_02_base_F: Car_F {
        class AcreRacks {
            class Rack_1 {
                displayName = "Dashboard Upper"; // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabledPositions[] = {};
                defaultComponents[] = {}; // Use this to attach simple components like Antennas, they will first attempt to fill empty connectors but will overide existing connectors - ACRE_13IN_UHF_BNC
                mountedRadio = "";
                isRadioRemovable = 1;
                intercom[] = {};
            };
            class Rack_2 {
                displayName = "Dashboard Lower"; // If you have multiple racks a text label helps identify the particular rack..
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"cargo", 0}};
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {};
            };
        };
    };

    class MRAP_03_base_F: Car_F {
        class AcreRacks {
            class Rack_1 {
                displayName = "Dashboard Upper"; // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC110";
                allowedPositions[] = {"driver", {"cargo", 0}}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabledPositions[] = {};
                defaultComponents[] = {}; // Use this to attach simple components like Antennas, they will first attempt to fill empty connectors but will overide existing connectors - ACRE_13IN_UHF_BNC
                mountedRadio = "";
                isRadioRemovable = 1;
                intercom[] = {};
            };
            class Rack_2 {
                displayName = "Dashboard Lower"; // If you have multiple racks a text label helps identify the particular rack..
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", {"cargo", 0}};
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {};
            };
        };
    };

    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(Dash); // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"intercom_1"};
            };
        };
    };

    class VTOL_01_base_F;
    class VTOL_01_unarmed_base_F: VTOL_01_base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = "Rack 1"; // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot", {"turret", {1}, {2}}};
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"intercom_1"};
            };

            class Rack_2 : Rack_1 {
                displayName = "Rack 2"; // Name is displayed in the interaction menu.
            };
        };
    };

    class Plane;
    class Plane_Base_F : Plane {
        class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(Dash); // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"intercom_1"};
            };

            class Rack_2 : Rack_1 {
                displayName = "Rack 2"; // Name is displayed in the interaction menu.
            };
        };
    };

    class Plane_Civil_01_base_F : Plane_Base_F {
        class AcreRacks {
            class Rack_1 {
                displayName = "Dash"; // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"intercom_1"};
            };
        };
    };

    class Tank;
    class Tank_F : Tank {
         class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(Dash); // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "commander", "gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"intercom_1"};
            };
        };
    };

    //class Car_F; // defined earlier.
    class Wheeled_APC_F : Car_F {
         class AcreRacks {
            class Rack_1 {
                displayName = CSTRING(Dash); // Name is displayed in the interaction menu.
                componentName = "ACRE_VRC103";
                allowedPositions[] = {"driver", "commander", "gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabledPositions[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"intercom_1"};
            };
        };
    };
};
