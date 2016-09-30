#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_data", "acre_sys_core"};
        AUTHOR;
        version = VERSION;
    };
};

#include "CfgEventhandlers.hpp"

class AcreCfgComponents {
    class Default;

    class ACRE_ComponentBase {
        simple            = false;
        type            = ACRE_COMPONENT_GENERIC;
    };

    class ACRE_BaseRadio : ACRE_ComponentBase {
        type = ACRE_COMPONENT_RADIO;
        isAcre = 1;
        name = "ACRE Base Radio";
        antennaLength = 1;
        sinadRating = 1;

        sensitivityMin = -116;
        sensitivityMax = -50;

        isDeployable = 0;
        deployedVehicleClass = "";

        class Interfaces {
            class CfgAcreDataInterface {
                getListInfo                    =    "acre_sys_data_fnc_noApiSystemFunction";

                setVolume                    =    "acre_sys_data_fnc_noApiSystemFunction";                // [0-1]
                getVolume                    =     "acre_sys_data_fnc_noApiSystemFunction";                // [] = 0-1

                setSpatial                    =    "acre_sys_data_fnc_noApiSystemFunction";
                getSpatial                    =    "acre_sys_data_fnc_noApiSystemFunction";

                setChannelData                 =    "acre_sys_data_fnc_noApiSystemFunction";            // [channelNumber, [channelData] ]
                getChannelData                =    "acre_sys_data_fnc_noApiSystemFunction";            // [channelNumber] = channelData
                getCurrentChannelData        =    "acre_sys_data_fnc_noApiSystemFunction";        // channelData (of current channel)


                getCurrentChannel            =    "acre_sys_data_fnc_noApiSystemFunction";        // [] = channelNumber
                setCurrentChannel            =    "acre_sys_data_fnc_noApiSystemFunction";        // [channelNumber]

                getStates                    =    "acre_sys_data_fnc_noApiSystemFunction";                // [] = [ [stateName, stateData], [stateName, stateData] ]
                getState                    =    "acre_sys_data_fnc_noApiSystemFunction";                // [stateName] = stateData
                setState                    =     "acre_sys_data_fnc_noApiSystemFunction";                // [stateName, stateData] = sets state
                setStateCritical            =     "acre_sys_data_fnc_noApiSystemFunction";                // [stateName, stateData] = sets state


                getOnOffState                =     "acre_sys_data_fnc_noApiSystemFunction";            // [] = 0/1
                setOnOffState                =     "acre_sys_data_fnc_noApiSystemFunction";            // [ZeroOrOne]

                initializeComponent            =     "acre_sys_data_fnc_noApiSystemFunction";

                getChannelDescription        =     "acre_sys_data_fnc_noApiSystemFunction";

                isExternalAudio                =    "acre_sys_data_fnc_noApiSystemFunction";
                getExternalAudioPosition    =     "acre_sys_data_fnc_noApiSystemFunction";


            };

            class CfgAcreTransmissionInterface {
                handleBeginTransmission        =     "acre_sys_data_fnc_noApiSystemFunction";
                handleEndTransmission        =    "acre_sys_data_fnc_noApiSystemFunction";

                handleSignalData            =    "acre_sys_data_fnc_noApiSystemFunction";
                handleMultipleTransmissions =    "acre_sys_data_fnc_noApiSystemFunction";

                handlePTTDown                =    "acre_sys_data_fnc_noApiSystemFunction";
                handlePTTUp                    =     "acre_sys_data_fnc_noApiSystemFunction";
            };

            class CfgAcreInteractInterface {
                openGui                        =     "acre_sys_data_fnc_noApiSystemFunction";                // [RadioId]
                closeGui                    =    "acre_sys_data_fnc_noApiSystemFunction";                // []
            };
        };
    };
};

class CfgVehicles {
    class Man;
    class CAManBase: Man {
        acre_antennaMemoryPoints[] = {{"LeftShoulder", "LeftShoulder"}};
        //acre_antennaMemoryPointsDir[] = {{"Spine3", "Neck"}};
        acre_antennaDirFnc = QUOTE(DFUNC(getAntennaDirMan));
    };
};


class CfgWeapons {

    class ACRE_GameComponentBase;

    class ItemRadio;
    class ItemRadioAcreFlagged : ItemRadio {
        scopeCurator = 1;
        scope = 1;
        class ItemInfo {
            mass = 0;
        };
    };

    class ACRE_BaseComponent : ACRE_GameComponentBase {
        acre_hasUnique = 1;
        scopeCurator = 1;
        scope = 1;
    };

    class ACRE_BaseRadio : ACRE_BaseComponent
    {
        displayName = "ACRE Radio";
        useActionTitle = "ACRE: Pickup Radio";
        acre_isRadio = 1;

        class Library
        {
            libTextDesc = "ACRE Radio";
        };
    };

};
