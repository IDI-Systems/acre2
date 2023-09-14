// WIP concept
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
            defaultFunction = QFUNC(api_setTransmitPower);
        };
        class toggleOnOff {
            required = false;
            defaultFunction = QFUNC(api_toggleOnOffState);
        };
        class getOnOffState {
            required = false;
            defaultFunction = QFUNC(api_getOnOffState);
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
