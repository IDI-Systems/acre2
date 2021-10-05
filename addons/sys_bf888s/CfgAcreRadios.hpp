class CfgAcreComponents {
    class ACRE_BaseRadio;

    class ACRE_BF888S_BASE: ACRE_BaseRadio {
        class Interfaces;
        isAcre = 1;
    };

    class ACRE_BF888S: ACRE_BF888S_BASE {
        name = QUOTE(NAME_BF888S);
        sinadRating = -119;
        sensitivityMin = -116;
        sensitivityMax = -50;
        isPackRadio = 0;
        isDeployable = 0;

        connectors[] = {
            {"Antenna", ACRE_CONNECTOR_SMA},
            {"Audio/Data", ACRE_CONNECTOR_U_283}
        };
        defaultComponents[] = {
            {0, "ACRE_22CM_UHF_SMA"},
        };

        class InterfaceClasses {
            CfgAcreDataInterface = "DefaultRadioInterface";
            CfgAcreInteractInterface = "DefaultRadioInterface";
            CfgAcreTransmissionInterface = "DefaultRadioInterface";
            CfgAcrePhysicalInterface = "DefaultRadioInterface";
        };

        class Interfaces: Interfaces {
            class CfgAcreDataInterface {
                getListInfo = QFUNC(getChannelDescription);

                setVolume = QFUNC(setVolume);                // [0-1]
                getVolume = QFUNC(getVolume);                // [] = 0-1

                setSpatial = QFUNC(setSpatial);
                getSpatial = QFUNC(getSpatial);

                setChannelData = QFUNC(setChannelData);            // [channelNumber, [channelData] ]
                getChannelData = QFUNC(getChannelData);            // [channelNumber] = channelData
                getCurrentChannelData = QFUNC(getCurrentChannelData);        // channelData (of current channel)


                getCurrentChannel = QFUNC(getCurrentChannel);        // [] = channelNumber
                setCurrentChannel = QFUNC(setCurrentChannel);        // [channelNumber]

                getStates = QFUNC(getStates);                // [] = [ [stateName, stateData], [stateName, stateData] ]
                getState = QFUNC(getState);                // [stateName] = stateData
                setState = QFUNC(setState);                // [stateName, stateData] = sets state

                getOnOffState = QFUNC(getOnOffState);            // [] = 0/1
                setOnOffState = QFUNC(setOnOffState);            // [ZeroOrOne]

                initializeComponent = QFUNC(initializeRadio);

                getChannelDescription = QFUNC(getChannelDescription);

                isExternalAudio = QFUNC(isExternalAudio);
            };

            class CfgAcrePhysicalInterface {
                getExternalAudioPosition = QFUNC(getExternalAudioPosition);
            };

            class CfgAcreTransmissionInterface {
                handleBeginTransmission = QFUNC(handleBeginTransmission);
                handleEndTransmission = QFUNC(handleEndTransmission);

                handleSignalData = QFUNC(handleSignalData);
                handleMultipleTransmissions = QFUNC(handleMultipleTransmissions);

                handlePTTDown = QFUNC(handlePTTDown);
                handlePTTUp = QFUNC(handlePTTUp);
            };

            class CfgAcreInteractInterface {
                openGui = QFUNC(openGui);                // [RadioId]
                closeGui = QFUNC(closeGui);                // []
            };
        };
    };
};
