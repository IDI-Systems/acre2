class CfgVehicles {
    // Vehicle rack vehicle definitions
    class ACRE_BaseRack;
    class ACRE_VRC110 : ACRE_BaseRack {
        displayName = "AN/VRC-110 Rack";
    };
    RADIO_ID_LIST(ACRE_VRC110);

    class ACRE_VRC103 : ACRE_BaseRack {
        displayName = "AN/VRC-103 Rack";
    };
    RADIO_ID_LIST(ACRE_VRC103);

    class ACRE_VRC111 : ACRE_BaseRack {
        displayName = "AN/VRC-111 Rack";
    };
    RADIO_ID_LIST(ACRE_VRC111);

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
                allowed[] = {"inside"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                defaultComponents[] = {}; // Use this to attach simple components like Antennas, they will first attempt to fill empty connectors but will overide existing connectors - ACRE_13IN_UHF_BNC
                mountedRadio = "";
                isRadioRemovable = 1;
            };
            class Rack_2 {
                name = "Dashboard Lower"; // If you have multiple racks a text label helps identify the particular rack..
                componentname = "ACRE_VRC103";
                allowed[] = {"driver"}; 
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
            };
        };
    };
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class AcreRacks {
            class Rack_1 {
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver","copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
            };
        };
    };
    class Plane;
    class Plane_Base_F : Plane {
        class AcreRacks {
            class Rack_1 {
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver","copilot"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
            };
        };
    };
    class Tank;
    class Tank_F : Tank {
         class AcreRacks {
            class Rack_1 {
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver","commander","gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
            };
        };
    };
    //class Car_F; // defined earlier.
    class Wheeled_APC_F : Car_F {
         class AcreRacks {
            class Rack_1 {
                name = "Dash"; // Name is displayed in the interaction menu.
                componentname = "ACRE_VRC103";
                allowed[] = {"driver","commander","gunner"}; // Who has access "inside" - anyone inside, "external" - provides access upto 10m away, "driver", "gunner", "copilot", "commander"
                defaultComponents[] = {};
                mountedRadio = "ACRE_PRC117F";
                isRadioRemovable = 0;
            };
        };        
    };
};
