//CfgAcreComponents.hpp

class CfgAcreComponents {
    class ACRE_ComponentBase;
    
    class ACRE_BaseAntenna : ACRE_ComponentBase {
        type            = ACRE_COMPONENT_ANTENNA;
        simple            = true;
        polarization     = VERTICAL_POLARIZE;
        heightAG        = AVERAGE_MAN_HEIGHT;
        orient             = 90;    // in degrees off of flat plane
        name             = "Default Antenna";
        connector         = ACRE_CONNECTOR_TNC;
        height             = 1.2; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\VHF_1.2m_whip_gain.aba";
    };

    class ACRE_14IN_UHF_TNC : ACRE_BaseAntenna {
        name             = "ACRE 14 Inch UHF Antenna TNC";
        connector         = ACRE_CONNECTOR_TNC;
        height             = 0.3556l; //meters
        heightAG        = AVERAGE_MAN_HEIGHT;
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\UHF_14_inch_gain.aba";
    };
    
    class ACRE_100CM_VHF_TNC : ACRE_BaseAntenna {
        name             = "1 Meter VHF Antenna TNC";
        connector         = ACRE_CONNECTOR_TNC;
        height             = 1; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\Thales_100cm_Whip_gain.aba";
    };
    
    class ACRE_100CM_VHF_BNC : ACRE_BaseAntenna {
        name             = "1 Meter VHF Antenna BNC";
        connector         = ACRE_CONNECTOR_BNC;
        height             = 1; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\Thales_100cm_Whip_gain.aba";
    };
    
    class ACRE_13IN_UHF_BNC : ACRE_BaseAntenna {
        name             = "13 Inch UHF Antenna BNC";
        connector         = ACRE_CONNECTOR_BNC;
        height             = 0.3302; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\UHF_13_inch_gain.aba";
    };
    
    class ACRE_2HALFINCH_UHF_TNC : ACRE_BaseAntenna {
        name             = "2.5 Inch UHF Antenna AN/PRC-343 ONLY";
        connector         = ACRE_CONNECTOR_TNC;
        height             = 0.062457; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\prc343_gain.aba";
    };
    
    class ACRE_OE303_VHF_BNC : ACRE_BaseAntenna {
        name             = "OE-303";
        connector         = ACRE_CONNECTOR_BNC;
        height             = 0.062457; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\oe303_gain.aba";
    };

    class ACRE_SEM52_SHORT_BNC : ACRE_BaseAntenna {
        name            = "SEM52SL Antenna Short (0.4m)";
        connector       = ACRE_CONNECTOR_BNC;
        height          = 0.4; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\sem52_short_gain.aba";
    };

    class ACRE_SEM52_LONG_BNC : ACRE_BaseAntenna {
        name            = "SEM52SL Antenna long (0.9m)";
        connector       = ACRE_CONNECTOR_BNC;
        height          = 0.9; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\sem52_long_gain.aba";
    };

    class ACRE_AT271_38 : ACRE_BaseAntenna {
        name            = "AT-271 Fishpole (PRC-77)";
        connector       = ACRE_CONNECTOR_3_8;
        height          = 2.88
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\AT-271_gain.aba";
    };

    class ACRE_123CM_VHF_TNC : ACRE_BaseAntenna {
        name             = "1.23 Meter VHF Whip Antenna TNC";
        connector         = ACRE_CONNECTOR_TNC;
        height             = 1.23; //meters
        binaryGainFile  = "\idi\acre\addons\sys_antenna\binary\Harris_123cm_Whip_gain.aba";
    };
};
