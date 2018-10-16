//CfgAcreComponents.hpp

class CfgAcreComponents {
    class ACRE_ComponentBase;

    class ACRE_BaseAntenna: ACRE_ComponentBase {
        type = ACRE_COMPONENT_ANTENNA;
        simple = true;
        polarization = VERTICAL_POLARIZE;
        heightAG = AVERAGE_MAN_HEIGHT;
        orient = 90; // in degrees off of flat plane
        name = "Default Antenna";
        shortName = "Default";
        connector = ACRE_CONNECTOR_TNC;
        height = 1.2; //meters
        binaryGainFile = QPATHTOF(binary\Thales_100cm_Whip_gain.aba);
    };

    class ACRE_100CM_VHF_TNC : ACRE_BaseAntenna {
        name = "1 Meter VHF Antenna TNC";
        shortName = "1M VHF TNC";
        connector = ACRE_CONNECTOR_TNC;
        height = 1;
        binaryGainFile = QPATHTOF(binary\Thales_100cm_Whip_gain.aba);
    };

    class ACRE_100CM_VHF_BNC : ACRE_BaseAntenna {
        name = "1 Meter VHF Antenna BNC";
        shortName = "1M VHF BNC";
        connector = ACRE_CONNECTOR_BNC;
        height = 1;
        binaryGainFile = QPATHTOF(binary\Thales_100cm_Whip_gain.aba);
    };

    class ACRE_2HALFINCH_UHF_TNC: ACRE_BaseAntenna {
        name = "2.5 Inch UHF Antenna AN/PRC-343 ONLY";
        shortName = "2.5 INCH UHF PRC343";
        connector = ACRE_CONNECTOR_TNC;
        height = 0.062457;
        binaryGainFile = QPATHTOF(binary\prc343_gain.aba);
    };

    class ACRE_SEM52_SHORT_BNC: ACRE_BaseAntenna {
        name = "SEM52SL/SEM70 Antenna Short (0.4m)";
        shortName = "0.4M SEM52/SEM70";
        connector = ACRE_CONNECTOR_BNC;
        height = 0.4;
        binaryGainFile = QPATHTOF(binary\sem52_short_gain.aba);
    };

    class ACRE_SEM52_LONG_BNC: ACRE_BaseAntenna {
        name = "SEM52SL Antenna long (0.9m)";
        shortName = "0.9M SEM52";
        connector = ACRE_CONNECTOR_BNC;
        height = 0.9;
        binaryGainFile = QPATHTOF(binary\sem52_long_gain.aba);
    };

    class ACRE_SEM70_LONG_BNC: ACRE_BaseAntenna {
        name = "SEM70 Antenna long (1.03m)";
        shortName = "1.03M SEM70";
        connector = ACRE_CONNECTOR_BNC;
        height = 1.03;
        binaryGainFile = QPATHTOF(binary\sem70_long_gain.aba);
    };

    class ACRE_AT271_38: ACRE_BaseAntenna {
        name = "AT-271 Fishpole (PRC-77)";
        shortName  = "AT-271 PRC-77";
        connector = ACRE_CONNECTOR_3_8;
        height = 2.88;
        binaryGainFile = QPATHTOF(binary\AT-271_gain.aba);
    };

    class ACRE_123CM_VHF_TNC: ACRE_BaseAntenna {
        name = "1.23 Meter VHF Whip Antenna TNC";
        shortName = "1.23M VHF TNC";
        connector = ACRE_CONNECTOR_TNC;
        height = 1.23;
        binaryGainFile = QPATHTOF(binary\Harris_123cm_Whip_gain.aba);
    };

    class ACRE_270CM_VEH_BNC: ACRE_BaseAntenna {
        name = "2.7 Meter Multiband Vehicular Whip Antenna BNC";
        shortName = "2.7M MB VEH BNC";
        connector = ACRE_CONNECTOR_BNC;
        height = 2.7;
        binaryGainFile = QPATHTOF(binary\RF_3183_AT0XX_gain.aba);
    };

    class ACRE_FA80_BNC: ACRE_BaseAntenna {
        name = "FA80 Vehicular Antenna";
        shortName = "FA80 VEH BNC";
        connector = ACRE_CONNECTOR_BNC;
        height = 1.66;
        binaryGainFile = QPATHTOF(binary\FA_80_gain.aba);
    };

    class ACRE_AS1729_38: ACRE_BaseAntenna {
        name = "AS-1729/VRC Vehicular (VRC-64)";
        shortName  = "AS-1729/VRC";
        connector = ACRE_CONNECTOR_3_8;
        height = 3.39;
        binaryGainFile = QPATHTOF(binary\AS-1729_VRC_gain.aba);
    };
};
