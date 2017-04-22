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
        class Interfaces {
            class CfgAcreDataInterface {
                getState                    = QFUNC(getState);
                setState                    = QFUNC(setState);
                handleComponentMessage      = QEFUNC(sys_data,noApiSystemFunction);

                initializeComponent         = QFUNC(initializeRack);

                attachComponent             = QEFUNC(sys_data,noApiSystemFunction);
                detachComponent             = QEFUNC(sys_data,noApiSystemFunction);
                mountRadio                  = QFUNC(vrc110MountRadio);
                unmountRadio                = QFUNC(vrc110UnmountRadio);
                mountableRadio              = QFUNC(vrc110MountableRadio);
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
                getState                    = QFUNC(getState);
                setState                    = QFUNC(setState);
                handleComponentMessage      = QEFUNC(sys_data,noApiSystemFunction);

                initializeComponent         = QFUNC(initializeRack);

                attachComponent             = QEFUNC(sys_data,noApiSystemFunction);
                detachComponent             = QEFUNC(sys_data,noApiSystemFunction);
                mountRadio                  = QFUNC(vrc103MountRadio);
                unmountRadio                = QFUNC(vrc103UnmountRadio);
                mountableRadio              = QFUNC(vrc103MountableRadio);
            };
        };
        class InterfaceClasses {
            CfgAcreDataInterface = "DefaultRackInterface";
            CfgAcreInteractInterface = "DefaultRadioInterface";
            CfgAcreTransmissionInterface = "DefaultRadioInterface";
            CfgAcrePhysicalInterface = "DefaultRadioInterface";
        };
    };
    class ACRE_VRC111 : ACRE_BaseRack {
        name = "AN/VRC-111";

        connectors[] =  {
                            {"Antenna", ACRE_CONNECTOR_BNC},
                            {"Audio In", ACRE_CONNECTOR_U_283},
                            {"Audio Out", ACRE_CONNECTOR_U_283},
                            {"Power In", ACRE_CONNECTOR_U_283},
                            {"Control/Radio", ACRE_CONNECTOR_CONN_18PIN}
                        };
        defaultComponents[] = {
                                /*{0, "ACRE_120CM_VHF_BNC"} no Antenna for now to avoid extr computation */
                            };
        class Interfaces {
            class CfgAcreDataInterface {
                getState                    = QFUNC(getState);
                setState                    = QFUNC(setState);
                handleComponentMessage      = QEFUNC(sys_data,noApiSystemFunction);

                initializeComponent         = QFUNC(initializeRack);

                attachComponent             = QEFUNC(sys_data,noApiSystemFunction);
                detachComponent             = QEFUNC(sys_data,noApiSystemFunction);
                mountRadio                  = QFUNC(vrc111MountRadio);
                unmountRadio                = QFUNC(vrc111UnmountRadio);
                mountableRadio              = QFUNC(vrc111MountableRadio);
            };
        };
        class InterfaceClasses {
            CfgAcreDataInterface = "DefaultRackInterface";
            CfgAcreInteractInterface = "DefaultRadioInterface";
            CfgAcreTransmissionInterface = "DefaultRadioInterface";
            CfgAcrePhysicalInterface = "DefaultRadioInterface";
        };
    };
    class ACRE_SEM90 : ACRE_BaseRack {
        name = "SEM90";

        connectors[] =  {
                            {"Antenna", ACRE_CONNECTOR_BNC},
                            {"Audio In", ACRE_CONNECTOR_U_283},
                            {"Audio Out", ACRE_CONNECTOR_U_283},
                            {"Power In", ACRE_CONNECTOR_U_283},
                            {"Control/Radio", ACRE_CONNECTOR_CONN_57PIN}
                        };
        defaultComponents[] = {
                                /*{0, "ACRE_120CM_VHF_BNC"} no Antenna for now to avoid extr computation */
                            };
        class Interfaces {
            class CfgAcreDataInterface {
                getState                    = QFUNC(getState);
                setState                    = QFUNC(setState);
                handleComponentMessage      = QEFUNC(sys_data,noApiSystemFunction);

                initializeComponent         = QFUNC(initializeRack);

                attachComponent             = QEFUNC(sys_data,noApiSystemFunction);
                detachComponent             = QEFUNC(sys_data,noApiSystemFunction);
                mountRadio                  = QFUNC(sem90MountRadio);
                unmountRadio                = QFUNC(sem90UnmountRadio);
                mountableRadio              = QFUNC(sem90MountableRadio);
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
