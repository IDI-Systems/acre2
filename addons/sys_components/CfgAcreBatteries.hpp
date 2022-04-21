class CfgAcreComponents {
    class ACRE_BaseBattery {

    };

    class BB_2590 {
        name = "BB-2590 Li-Ion Battery";
        // w,h,l in cm, weight in kg
        dimensions[] = { 61, 127, 112, 1.4 };

        // Draw and voltage
        sections = 2;
        voltage = 28.8;
        max_voltage = 33.0;

        // 12v mode Ah
        capacity = 15;
        discharge = 10;     // amp/continous/sections
        pulse_discharge[] = { 18, 5000, 25000}; // 5on/25off / section

        connector = "BB-2590 Connector";
    };

    class ALI_130 {
        name = "ALI-130 Li-Ion Battery";
        // l, w, h, weight in kg
        dimensions[] = { 41, 86, 71, 0.34 };

        sections = 1;
        voltage = 10.8;
        max_voltage = 12.6;

        capacity = 5.8;
        discharge = 6;
        pulse_discharge = {40, 1, -1 };

        connector = "MBITR_148";
    };
};
