//CfgAcreRadioModes.hpp

class CfgAcreRadioModes {
    class singleChannel {
        availability = QUOTE(DFUNC(sc_muting));
        speaking = QUOTE(DFUNC(sc_speaking));
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
        availability = QUOTE(DFUNC(sc_muting));
        speaking = QUOTE(DFUNC(sc_speaking));
        channelHash[] = {
            "frequencyTX",
            "frequencyRX",
            "power",
            "mode"
        };
    };
};