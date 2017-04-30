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

    class ACRE_BaseRadio: ACRE_ComponentBase {
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
                getListInfo = QEFUNC(sys_data,noApiSystemFunction);

                setVolume = QEFUNC(sys_data,noApiSystemFunction);                // [0-1]
                getVolume = QEFUNC(sys_data,noApiSystemFunction);                // [] = 0-1

                setSpatial = QEFUNC(sys_data,noApiSystemFunction);
                getSpatial = QEFUNC(sys_data,noApiSystemFunction);

                setChannelData = QEFUNC(sys_data,noApiSystemFunction);            // [channelNumber, [channelData] ]
                getChannelData = QEFUNC(sys_data,noApiSystemFunction);            // [channelNumber] = channelData
                getCurrentChannelData = QEFUNC(sys_data,noApiSystemFunction);        // channelData (of current channel)


                getCurrentChannel = QEFUNC(sys_data,noApiSystemFunction);        // [] = channelNumber
                setCurrentChannel = QEFUNC(sys_data,noApiSystemFunction);        // [channelNumber]

                getStates = QEFUNC(sys_data,noApiSystemFunction);                // [] = [ [stateName, stateData], [stateName, stateData] ]
                getState = QEFUNC(sys_data,noApiSystemFunction);                // [stateName] = stateData
                setState = QEFUNC(sys_data,noApiSystemFunction);                // [stateName, stateData] = sets state
                setStateCritical = QEFUNC(sys_data,noApiSystemFunction);                // [stateName, stateData] = sets state


                getOnOffState = QEFUNC(sys_data,noApiSystemFunction);            // [] = 0/1
                setOnOffState = QEFUNC(sys_data,noApiSystemFunction);            // [ZeroOrOne]

                initializeComponent = QEFUNC(sys_data,noApiSystemFunction);

                getChannelDescription = QEFUNC(sys_data,noApiSystemFunction);

                isExternalAudio = QEFUNC(sys_data,noApiSystemFunction);
                getExternalAudioPosition = QEFUNC(sys_data,noApiSystemFunction);


            };

            class CfgAcreTransmissionInterface {
                handleBeginTransmission = QEFUNC(sys_data,noApiSystemFunction);
                handleEndTransmission = QEFUNC(sys_data,noApiSystemFunction);

                handleSignalData = QEFUNC(sys_data,noApiSystemFunction);
                handleMultipleTransmissions = QEFUNC(sys_data,noApiSystemFunction);

                handlePTTDown = QEFUNC(sys_data,noApiSystemFunction);
                handlePTTUp = QEFUNC(sys_data,noApiSystemFunction);
            };

            class CfgAcreInteractInterface {
                openGui = QEFUNC(sys_data,noApiSystemFunction);                // [RadioId]
                closeGui = QEFUNC(sys_data,noApiSystemFunction);                // []
            };
        };
    };
    
    class ACRE_BaseRack : ACRE_ComponentBase {
        type = ACRE_COMPONENT_RACK;
        isAcre = 1;
        name = "ACRE Rack";
        
        // Amplification
        // Speaker
        // Antenna slots.
        connectors[] = {};
        defaultComponents[] = {};
        
        class Interfaces {
            class CfgAcreDataInterface {
                getState                    = "acre_sys_rack_fnc_getState";
                setState                    = "acre_sys_rack_fnc_setState";
                handleComponentMessage      = "acre_sys_data_fnc_noApiSystemFunction";

                initializeComponent         = "acre_sys_data_fnc_noApiSystemFunction";

                attachComponent             = "acre_sys_data_fnc_noApiSystemFunction";
                detachComponent             = "acre_sys_data_fnc_noApiSystemFunction";
                mountRadio                  = "acre_sys_data_fnc_noApiSystemFunction";
                unmountRadio                = "acre_sys_data_fnc_noApiSystemFunction";
                mountableRadio              = "acre_sys_data_fnc_noApiSystemFunction";
            };
        };
    };
};

class CfgVehicles {
    class Man;
    class CAManBase: Man {
        acre_antennaMemoryPoints[] = {{"LeftShoulder", "LeftShoulder"}};
        //acre_antennaMemoryPointsDir[] = {{"Spine3", "Neck"}};
        acre_antennaDirFnc = QFUNC(getAntennaDirMan);
    };
    class Thing;
    class ACRE_BaseRack : Thing {
        author = "ACRE2 Team";// TODO: sort out
        displayName = "ACRE Base Rack";
        scope = 0;
        mass = 0;
        vehicleClass = "";
        
        acre_isRack = 1;
        acre_hasUnique = 1;
    };

};


class CfgWeapons {

    class ACRE_GameComponentBase;

    class ItemRadio;
    class ItemRadioAcreFlagged: ItemRadio {
        scopeCurator = 1;
        scope = 1;
        class ItemInfo {
            mass = 0;
        };
    };

    class ACRE_BaseComponent: ACRE_GameComponentBase {
        acre_hasUnique = 1;
        scopeCurator = 1;
        scope = 1;
    };

    class ACRE_BaseRadio: ACRE_BaseComponent {
        displayName = "ACRE Radio";
        useActionTitle = "ACRE: Pickup Radio";
        acre_isRadio = 1;

        class Library {
            libTextDesc = "ACRE Radio";
        };
    };

};
