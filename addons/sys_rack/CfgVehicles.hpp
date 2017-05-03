class CfgVehicles {
    // Vehicle rack vehicle definitions
    class ACRE_BaseRack;
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
    class Car_F;
    class MRAP_01_base_F : Car_F {
        class AcreRacks {
            class Rack_1 {
                name = "Dashboard Upper"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC110";
                allowed[] = {"driver", {"cargo", 0}}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabled[] = {};
                defaultComponents[] = {}; // Use this to attach simple components like Antennas, they will first attempt to fill empty connectors but will overide existing connectors - ACRE_13IN_UHF_BNC
                mountedRadio = "";
                isRadioRemovable = 1;
                intercom[] = {};
            };
            class Rack_2 {
                name = "Dashboard Lower"; // If you have multiple racks a text label helps identify the particular rack..
                componentname = "ACRE_VRC103";
                allowed[] = {"driver", {"cargo", 0}};
                disabled[] = {};
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
                name = "Dashboard Upper"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC110";
                allowed[] = {"driver", {"cargo", 0}}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabled[] = {};
                defaultComponents[] = {}; // Use this to attach simple components like Antennas, they will first attempt to fill empty connectors but will overide existing connectors - ACRE_13IN_UHF_BNC
                mountedRadio = "";
                isRadioRemovable = 1;
                intercom[] = {};
            };
            class Rack_2 {
                name = "Dashboard Lower"; // If you have multiple racks a text label helps identify the particular rack..
                componentname = "ACRE_VRC103";
                allowed[] = {"driver", {"cargo", 0}};
                disabled[] = {};
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
                name = "Dashboard Upper"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC110";
                allowed[] = {"driver", {"cargo", 0}}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabled[] = {};
                defaultComponents[] = {}; // Use this to attach simple components like Antennas, they will first attempt to fill empty connectors but will overide existing connectors - ACRE_13IN_UHF_BNC
                mountedRadio = "";
                isRadioRemovable = 1;
                intercom[] = {};
            };
            class Rack_2 {
                name = "Dashboard Lower"; // If you have multiple racks a text label helps identify the particular rack..
                componentname = "ACRE_VRC103";
                allowed[] = {"driver", {"cargo", 0}};
                disabled[] = {};
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
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver", "copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabled[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"crew"};
            };
        };
    };

    class VTOL_01_base_F;
    class VTOL_01_unarmed_base_F: VTOL_01_base_F {
        class AcreRacks {
            class Rack_1 {
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver", "copilot", {"turret", {1}, {2}}};
                disabled[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"crew"};
            };
        };
    };

    class Plane;
    class Plane_Base_F : Plane {
        class AcreRacks {
            class Rack_1 {
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver", "copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabled[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"crew"};
            };
        };
    };

    class Tank;
    class Tank_F : Tank {
         class AcreRacks {
            class Rack_1 {
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver", "commander", "gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabled[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"crew"};
            };
        };
    };

    //class Car_F; // defined earlier.
    class Wheeled_APC_F : Car_F {
         class AcreRacks {
            class Rack_1 {
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver", "commander", "gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                disabled[] = {};
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
                intercom[] = {"crew"};
            };
        };
    };
};
