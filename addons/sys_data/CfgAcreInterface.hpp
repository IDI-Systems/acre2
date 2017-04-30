#define ACRE_DATA_RETURNTYPE_ANY    0
#define ACRE_DATA_RETURNTYPE_ARRAY    1
#define ACRE_DATA_RETURNTYPE_SCALAR    2
#define ACRE_DATA_RETURNTYPE_STRING    3
#define ACRE_DATA_RETURNTYPE_BOOL    4

#define ACRE_DATA_SETTER    0


class CfgAcreDataInterface {
    class DefaultComponentInterface {
        class Default {
            required = 0;
        };

        class DefaultSetter: Default {
            priority = ACRE_DATA_NETPRIORITY_LOW;
            returnType = ACRE_DATA_RETURNTYPE_ANY;
            uniqueKey = 0;
            handler = QFUNC(handleSetData);
            type = ACRE_DATA_SETTER;
        };

        class DefaultGetter: Default {
            priority = ACRE_DATA_NETPRIORITY_NONE;
            returnType = ACRE_DATA_RETURNTYPE_ANY;
            handler = "";//QFUNC(handleGetData);
        };

        class attachComponent: DefaultSetter {
            required = 0;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            uniqueKey = 1;
            handler = QEFUNC(sys_components,attachComponentHandler);
        };

        class detachComponent: DefaultSetter {
            required = 0;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            uniqueKey = 1;
            handler = QEFUNC(sys_components,detachComponentHandler);
        };

        class handleComponentMessage: DefaultGetter {
            required = 1;
            handler = QEFUNC(sys_components,handleComponentMessageHandler);
        };

        class initializeComponent: DefaultSetter {
            required = 1;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            handler = QEFUNC(sys_components,initializeComponent);
        };
    };

    class DefaultRadioInterface: DefaultComponentInterface {

        class getListInfo: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_STRING;
        };

        class setVolume: DefaultSetter {
            priority = ACRE_DATA_NETPRIORITY_LOW;
            required = 1;
        };

        class getVolume: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_SCALAR;
        };

        class setSpatial: DefaultSetter {
            priority = ACRE_DATA_NETPRIORITY_LOW;
            required = 1;
        };

        class getSpatial: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_SCALAR;
        };

        class setChannelData: DefaultSetter {
            required = 1;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            uniqueKey = 1;
            handler = QFUNC(handleSetChannel);
        };

        class getChannelData: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_ARRAY;
        };

        class getCurrentChannelData: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_ARRAY;
        };

        class setCurrentChannel: DefaultSetter {
            required = 1;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            handler = QFUNC(handleSetChannel);
        };

        class getCurrentChannel: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_SCALAR;
        };

        class getStates: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_ARRAY;
        };

        class getState: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_ARRAY;
        };

        class setState: DefaultSetter {
            priority = ACRE_DATA_NETPRIORITY_LOW;
            uniqueKey = 1;
            required = 1;
        };

        class setStateCritical: DefaultSetter {
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            uniqueKey = 1;
            required = 1;
        };

        class getOnOffState: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_SCALAR;
        };

        class setOnOffState: DefaultSetter {
            required = 1;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            handler = QFUNC(handleSetChannel);
        };

        class getChannelDescription: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_STRING;
        };

        class isExternalAudio: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_BOOL;
        };
    };
    
    class DefaultRackInterface : DefaultComponentInterface {        
        class getState : DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_ARRAY;
        };

        class setState : DefaultSetter {
            priority = ACRE_DATA_NETPRIORITY_LOW;
            uniqueKey = 1;
            required = 1;
        };

        class mountRadio : DefaultSetter {
            required = 1;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
        };

        class unmountRadio : DefaultSetter {
            required = 1;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
        };
        
        class mountableRadio : DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_BOOL;
        };
    };
    
};

class CfgAcreTransmissionInterface {
    class DefaultRadioInterface {
        class Default {
            returnType = ACRE_DATA_RETURNTYPE_ANY;
            required = 1;
        };

        class DefaultAction: Default {
            priority = ACRE_DATA_NETPRIORITY_NONE;
            handler = "";
        };

        class handleSignalData: DefaultAction {
        };

        class handleBeginTransmission: DefaultAction {
        };

        class handleEndTransmission: DefaultAction {
            handler = QEFUNC(sys_signal,handleEndTransmission);
        };

        class handleMultipleTransmissions: DefaultAction {
            returnType = ACRE_DATA_RETURNTYPE_ARRAY;
        };

        class handlePTTDown: DefaultAction {
            returnType = ACRE_DATA_RETURNTYPE_BOOL;
        };

        class handlePTTUp: DefaultAction {
            returnType = ACRE_DATA_RETURNTYPE_BOOL;
        };
    };
};

class CfgAcreInteractInterface {
    class DefaultRadioInterface {
        class Default {
            returnType = ACRE_DATA_RETURNTYPE_ANY;
            required = 0;
        };

        class DefaultAction: Default {
            priority = ACRE_DATA_NETPRIORITY_NONE;
        };

        class openGui: DefaultAction {
            required = 1;
            handler = QFUNC(openGui);
        };

        class closeGui: DefaultAction {
            required = 1;
            handler = QFUNC(closeGui);
        };
    };
};

class CfgAcreStateInterface {

    class DefaultRadioInterface {
        class Default {
            returnType = ACRE_DATA_RETURNTYPE_ANY;
            required = 0;
        };

        class DefaultSetter: Default {
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            handler = QFUNC(handleSetData);
        };

        class DefaultGetter: Default {
            priority = ACRE_DATA_NETPRIORITY_NONE;
            handler = QFUNC(handleGetData);
        };

        class getRadioState: DefaultGetter {
            returnType = ACRE_DATA_RETURNTYPE_ARRAY;
            required = 1;
        };

        class setRadioState: DefaultSetter {
            required = 1;
            priority = ACRE_DATA_NETPRIORITY_HIGH;
        };
    };

};

class CfgAcrePhysicalInterface {
    class DefaultRadioInterface {
        class Default {
            returnType = ACRE_DATA_RETURNTYPE_ANY;
            required = 0;
        };

        class DefaultSetter: Default {
            priority = ACRE_DATA_NETPRIORITY_HIGH;
            handler = QFUNC(handleSetData);
        };

        class DefaultGetter: Default {
            priority = ACRE_DATA_NETPRIORITY_NONE;
            handler = QFUNC(handleGetData);
        };

        class getExternalAudioPosition: DefaultGetter {
            required = 1;
            returnType = ACRE_DATA_RETURNTYPE_ARRAY;
        };
    };
};
