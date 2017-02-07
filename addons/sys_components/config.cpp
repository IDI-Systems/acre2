#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"acre_main", "acre_sys_data", "acre_sys_core"};
        author = ECSTRING(main,Author);
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class CfgAcreComponents {
    class Default;

    class ACRE_ComponentBase {
        simple = false;
        type = ACRE_COMPONENT_GENERIC;
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
                getListInfo                 = QUOTE(EFUNC(sys_data,noApiSystemFunction));

                setVolume                   = QUOTE(EFUNC(sys_data,noApiSystemFunction));                // [0-1]
                getVolume                   = QUOTE(EFUNC(sys_data,noApiSystemFunction));                // [] = 0-1

                setSpatial                  = QUOTE(EFUNC(sys_data,noApiSystemFunction));
                getSpatial                  = QUOTE(EFUNC(sys_data,noApiSystemFunction));

                setChannelData              = QUOTE(EFUNC(sys_data,noApiSystemFunction));            // [channelNumber, [channelData] ]
                getChannelData              = QUOTE(EFUNC(sys_data,noApiSystemFunction));            // [channelNumber] = channelData
                getCurrentChannelData       = QUOTE(EFUNC(sys_data,noApiSystemFunction));        // channelData (of current channel)


                getCurrentChannel           = QUOTE(EFUNC(sys_data,noApiSystemFunction));        // [] = channelNumber
                setCurrentChannel           = QUOTE(EFUNC(sys_data,noApiSystemFunction));        // [channelNumber]

                getStates                   = QUOTE(EFUNC(sys_data,noApiSystemFunction));                // [] = [ [stateName, stateData], [stateName, stateData] ]
                getState                    = QUOTE(EFUNC(sys_data,noApiSystemFunction));                // [stateName] = stateData
                setState                    = QUOTE(EFUNC(sys_data,noApiSystemFunction));                // [stateName, stateData] = sets state
                setStateCritical            = QUOTE(EFUNC(sys_data,noApiSystemFunction));                // [stateName, stateData] = sets state


                getOnOffState               = QUOTE(EFUNC(sys_data,noApiSystemFunction));            // [] = 0/1
                setOnOffState               = QUOTE(EFUNC(sys_data,noApiSystemFunction));            // [ZeroOrOne]

                initializeComponent         = QUOTE(EFUNC(sys_data,noApiSystemFunction));

                getChannelDescription       = QUOTE(EFUNC(sys_data,noApiSystemFunction));

                isExternalAudio             = QUOTE(EFUNC(sys_data,noApiSystemFunction));
                getExternalAudioPosition    = QUOTE(EFUNC(sys_data,noApiSystemFunction));


            };

            class CfgAcreTransmissionInterface {
                handleBeginTransmission     = QUOTE(EFUNC(sys_data,noApiSystemFunction));
                handleEndTransmission       = QUOTE(EFUNC(sys_data,noApiSystemFunction));

                handleSignalData            = QUOTE(EFUNC(sys_data,noApiSystemFunction));
                handleMultipleTransmissions = QUOTE(EFUNC(sys_data,noApiSystemFunction));

                handlePTTDown               = QUOTE(EFUNC(sys_data,noApiSystemFunction));
                handlePTTUp                 = QUOTE(EFUNC(sys_data,noApiSystemFunction));
            };

            class CfgAcreInteractInterface {
                openGui                     = QUOTE(EFUNC(sys_data,noApiSystemFunction));                // [RadioId]
                closeGui                    = QUOTE(EFUNC(sys_data,noApiSystemFunction));                // []
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
