//CfgAcreRadioModes.hpp

class CfgAcreRadioModes {
    class singleChannel {
        availability = QFUNC(sc_muting);
        speaking = QFUNC(sc_speaking);
        channelHash[] = {
            "frequencyTX",
            "frequencyRX",
            "power",
            "mode",
            "CTCSSTx",
            "CTCSSRx",
            "modulation",
            "encryption",
            "TEK",
            "trafficRate",
            "syncLength"
        };
    };

    class sem70AKW {
        availability = QFUNC(sem70akw_muting);
        speaking = QFUNC(sem70akw_speaking);
        channelHash[] = {
            "frequencies",
            "frequencyTX",
            "frequencyRX",
            "power",
            "mode",
            "networkID"
        };
    };

    class singleChannelPRR {
        availability = QFUNC(sc_muting);
        speaking = QFUNC(sc_speaking);
        channelHash[] = {
            "frequencyTX",
            "frequencyRX",
            "power",
            "mode"
        };
    };
};
