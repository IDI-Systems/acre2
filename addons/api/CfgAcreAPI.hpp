// WIP concept
class CfgAcreAPI {
    class RadioAPIFunctions {
        class setChannel {
            required = 1;
        };
        class setVolume {
            required = 1;
        };
        class setTransmitPower {
            required = 0;
            defaultFunction = QFUNC(api_setTransmitPower);
        };
        class toggleOnOff {
            required = 0;
            defaultFunction = QFUNC(api_toggleOnOffState);
        };
        class getOnOffState {
            required = 0;
            defaultFunction = QFUNC(api_getOnOffState);
        };
        class getVolume {
            required = 1;
        };
        class getChannel {
            required = 1;
        };
        class getTransmitPower {
            required = 1;
        };
    };
};
