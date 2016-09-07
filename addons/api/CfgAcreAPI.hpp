#define true 1
#define false 0
class CfgAcreAPI {
    class RadioAPIFunctions {
        class setChannel {
            required = true;
        };
        class setVolume {
            required = true;
        };
        class setTransmitPower {
            required = false;
            defaultFunction = QUOTE(DFUNC(api_setTransmitPower));
        };
        class toggleOnOff {
            required = false;
            defaultFunction = QUOTE(DFUNC(api_toggleOnOffState));
        };
        class getOnOffState {
            required = false;
            defaultFunction = QUOTE(DFUNC(api_getOnOffState));
        };
        class getVolume {
            required = true;
        };
        class getChannel {
            required = true;
        };
        class getTransmitPower {
            required = true;
        };
    };
};