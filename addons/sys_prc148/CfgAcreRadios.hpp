class CfgAcreComponents {
    class ACRE_BaseRadio;

    class ACRE_PRC148_base: ACRE_BaseRadio {
        class Interfaces;
        isAcre = 1;
    };

    class ACRE_PRC148: ACRE_PRC148_base {
        name = QUOTE(NAME_PRC148);
        sinadRating = -116; // SINAD rating for radio
        sensitivityMin = -116;
        sensitivityMax = -50;
        isPackRadio = 0;
        isDeployable = 0;

        /**
         Array of arrays, each item being {connectorLabel, connectorType}
        */

        connectors[] = {
            {"Antenna", ACRE_CONNECTOR_TNC},
            {"Audio/Data", ACRE_CONNECTOR_U_283},
            {"Side Connector", ACRE_CONNECTOR_CONN_18PIN}
        };

        defaultComponents[] = {
            {0, "ACRE_100CM_VHF_TNC"}
        };

        class InterfaceClasses {
            CfgAcreDataInterface = "DefaultRadioInterface";
            CfgAcreInteractInterface = "DefaultRadioInterface";
            CfgAcreTransmissionInterface = "DefaultRadioInterface";
            CfgAcrePhysicalInterface = "DefaultRadioInterface";
        };

        class Interfaces: Interfaces {
            class CfgAcreDataInterface {
                getListInfo = QFUNC(getListInfo);

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
                setStateCritical = QFUNC(setState);                // [stateName, stateData] = sets state


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
    /*
    class ACRE_PRC148_UHF: ACRE_PRC148 {
        name = QUOTE(NAME_PRC148_UHF);
        defaultAntennas[] = {
            {0, "ACRE_14IN_UHF_TNC"}
        };
    };
    */
};
