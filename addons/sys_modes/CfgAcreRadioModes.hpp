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
