class CfgAcreComponents
{
    class ACRE_BaseRadio;

    class ACRE_PRC148_base : ACRE_BaseRadio {
        class Interfaces;
        isAcre = 1;
    };

    class ACRE_PRC148 : ACRE_PRC148_base {
        name = "AN/PRC-148 VHF";
        sinadRating = -116; // SINAD rating for radio
        sensitivityMin = -116-7;
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
                {0, "ACRE_120CM_VHF_TNC"}
            };
        class InterfaceClasses {
            CfgAcreDataInterface = "DefaultRadioInterface";
            CfgAcreInteractInterface = "DefaultRadioInterface";
            CfgAcreTransmissionInterface = "DefaultRadioInterface";
            CfgAcrePhysicalInterface = "DefaultRadioInterface";
        };

        class Interfaces: Interfaces {
            class CfgAcreDataInterface {
                getListInfo                    =    QUOTE(DFUNC(getListInfo));

                setVolume                    =    QUOTE(DFUNC(setVolume));                // [0-1]
                getVolume                    =     QUOTE(DFUNC(getVolume));                // [] = 0-1

                setSpatial                    =    QUOTE(DFUNC(setSpatial));
                getSpatial                    =    QUOTE(DFUNC(getSpatial));

                setChannelData                 =    QUOTE(DFUNC(setChannelData));            // [channelNumber, [channelData] ]
                getChannelData                =    QUOTE(DFUNC(getChannelData));            // [channelNumber] = channelData
                getCurrentChannelData        =    QUOTE(DFUNC(getCurrentChannelData));        // channelData (of current channel)


                getCurrentChannel            =    QUOTE(DFUNC(getCurrentChannel));        // [] = channelNumber
                setCurrentChannel            =    QUOTE(DFUNC(setCurrentChannel));        // [channelNumber]

                getStates                    =    QUOTE(DFUNC(getStates));                // [] = [ [stateName, stateData], [stateName, stateData] ]
                getState                    =    QUOTE(DFUNC(getState));                // [stateName] = stateData
                setState                    =     QUOTE(DFUNC(setState));                // [stateName, stateData] = sets state
                setStateCritical            =     QUOTE(DFUNC(setState));                // [stateName, stateData] = sets state


                getOnOffState                =     QUOTE(DFUNC(getOnOffState));            // [] = 0/1
                setOnOffState                =     QUOTE(DFUNC(setOnOffState));            // [ZeroOrOne]

                initializeComponent            =     QUOTE(DFUNC(initializeRadio));

                getChannelDescription        =     QUOTE(DFUNC(getChannelDescription));

                isExternalAudio                =    QUOTE(DFUNC(isExternalAudio));
            };

            class CfgAcrePhysicalInterface {
                getExternalAudioPosition    =     QUOTE(DFUNC(getExternalAudioPosition));
            };

            class CfgAcreTransmissionInterface {
                handleBeginTransmission        =     QUOTE(DFUNC(handleBeginTransmission));
                handleEndTransmission        =    QUOTE(DFUNC(handleEndTransmission));

                handleSignalData            =    QUOTE(DFUNC(handleSignalData));
                handleMultipleTransmissions =    QUOTE(DFUNC(handleMultipleTransmissions));

                handlePTTDown                =    QUOTE(DFUNC(handlePTTDown));
                handlePTTUp                    =     QUOTE(DFUNC(handlePTTUp));
            };

            class CfgAcreInteractInterface {
                openGui                        =     QUOTE(DFUNC(openGui));                // [RadioId]
                closeGui                    =    QUOTE(DFUNC(closeGui));                // []
            };
        };
    };
    /*
    class ACRE_PRC148_UHF : ACRE_PRC148 {
        name = "AN/PRC-148 UHF";
        defaultAntennas[] = {
                                {0, "ACRE_14IN_UHF_TNC"}
                            };
    };
    */
};
