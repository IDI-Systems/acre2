class CfgAcreComponents {
    class ACRE_BaseRack;
    class ACRE_VRC110 : ACRE_BaseRack {
        name = "AN/VRC-110";

        connectors[] =  {
                            {"Antenna", ACRE_CONNECTOR_BNC},
                            {"Audio In", ACRE_CONNECTOR_U_283},
                            {"Audio Out", ACRE_CONNECTOR_U_283},
                            {"Power In", ACRE_CONNECTOR_U_283},
                            {"Radio", ACRE_CONNECTOR_CONN_32PIN}
                        };
        defaultComponents[] = {
                                /*{0, "ACRE_120CM_VHF_BNC"} no Antenna for now to avoid extr computation */
                            };
        //TODO figure out interfaces.
        class Interfaces {
            class CfgAcreDataInterface {
                getState                    = "acre_sys_rack_fnc_getState";
                setState                    = "acre_sys_rack_fnc_setState";
                handleComponentMessage      = "acre_sys_data_fnc_noApiSystemFunction";

                initializeComponent         = "acre_sys_rack_fnc_initializeRack";

                attachComponent             = "acre_sys_data_fnc_noApiSystemFunction";
                detachComponent             = "acre_sys_data_fnc_noApiSystemFunction";
                mountRadio                  = "acre_sys_rack_fnc_mountRadio110";
                unmountRadio                = "acre_sys_rack_fnc_unmountRadio110";
                mountableRadio              = "acre_sys_rack_fnc_mountableRadio110";
            };
        };
        class InterfaceClasses {
            CfgAcreDataInterface = "DefaultRackInterface";
            CfgAcreInteractInterface = "DefaultRadioInterface";
            CfgAcreTransmissionInterface = "DefaultRadioInterface";
            CfgAcrePhysicalInterface = "DefaultRadioInterface";
        };
    };
    class ACRE_VRC103 : ACRE_BaseRack {
        name = "AN/VRC-103";

        connectors[] =  {
                            {"Audio/Data/Fill", ACRE_CONNECTOR_U_283},
                            /*{"GPS", }
                            {"Data/Retrans", }, large circular pin connector*/
                            {"VHF Antenna", ACRE_CONNECTOR_BNC},
                            //{"Accessory", },
                            {"UHF Antenna", ACRE_CONNECTOR_BNC},
                            {"Control/Radio", ACRE_CONNECTOR_CONN_26PIN}
                        };
        defaultComponents[] = {
                                /*{1, "ACRE_120CM_VHF_BNC"} no Antenna for now to avoid extr computation */
                            };
        class Interfaces {
            class CfgAcreDataInterface {
                getState                    = "acre_sys_rack_fnc_getState";
                setState                    = "acre_sys_rack_fnc_setState";
                handleComponentMessage      = "acre_sys_data_fnc_noApiSystemFunction";

                initializeComponent         = "acre_sys_rack_fnc_initializeRack";

                attachComponent             = "acre_sys_data_fnc_noApiSystemFunction";
                detachComponent             = "acre_sys_data_fnc_noApiSystemFunction";
                mountRadio                  = "acre_sys_rack_fnc_mountRadio103";
                unmountRadio                = "acre_sys_rack_fnc_unmountRadio103";
                mountableRadio              = "acre_sys_rack_fnc_mountableRadio103";
            };
        };        
        class InterfaceClasses {
            CfgAcreDataInterface = "DefaultRackInterface";
            CfgAcreInteractInterface = "DefaultRadioInterface";
            CfgAcreTransmissionInterface = "DefaultRadioInterface";
            CfgAcrePhysicalInterface = "DefaultRadioInterface";
        };
    };
};
