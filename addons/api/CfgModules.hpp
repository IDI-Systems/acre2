class CfgFactionClasses {
    class NO_CATEGORY;
    class GVAR(mission_setup): NO_CATEGORY {
        displayName = "ACRE";
    };
};
class CfgVehicles {
    class Logic;
    class Module_F: Logic { class ArgumentsBaseUnits { class Units; }; class ModuleDescription { class AnyBrain; }; };

    class GVAR(basicMissionSetup): Module_F {
        scope = 2;
        displayName = "Basic Mission Setup";
        author = ECSTRING(main,Author);
        category = QGVAR(mission_setup);

        function = "AcreModules_fnc_basicMissionSetup";
        functionPriority = 1;
        isGlobal = 2;
        isTriggerActivated = 0;

        // Menu displayed when the module is placed or double-clicked on by Zeus
        curatorInfoType = "RscDisplayAttributeModuleNuke";

        // Module arguments
        class Arguments {
            class RadioSetup {
                displayName = "Channels Per Side";
                description = "Set to true to have each side have different ACRE radio frequencies";
                typeName = "BOOL";
                class values { };
            };
            class BabelSetup {
                displayName = "Babel Language Per Side";
                description = "Select whether each side has its own language, and whether they also share a common tongue.";
                typeName = "NUMBER";
                class values {
                    class AllDifferent    {name = "Per-Side";    value = 1; };
                    class SharingDifferent    {name = "Per-Side /w Common"; value = 2; default = 2; };
                    class No { name = "No Babel"; value = 0; };
                };
            };
            class DefaultRadio {
                displayName = "Default Radio 1";
                description = "Default radio for ACRE to give player";
                defaultValue = "ACRE_PRC343";
            };
            class DefaultRadio_Two {
                displayName = "Default Radio 2";
                description = "Default radio for ACRE to give player";
                defaultValue = "";
            };
            class DefaultRadio_Three {
                displayName = "Default Radio 3";
                description = "Default radio for ACRE to give player";
                defaultValue = "";
            };
            class DefaultRadio_Four {
                displayName = "Default Radio 4";
                description = "Default radio for ACRE to give player";
                defaultValue = "";
            };
        };

        class ModuleDescription: ModuleDescription {
            description = "This module defines basic ACRE setup for a mission";
            sync[] = {};
        };
    };

    // Unused, backwards compatibility only
    class GVAR(DifficultySettings): Module_F {
        scope = 1;
        displayName = "Difficulty Settings";
        category = QGVAR(mission_setup);

        functionPriority = 20;
        isGlobal = 2;
        isTriggerActivated = 0;

        // Menu displayed when the module is placed or double-clicked on by Zeus
        curatorInfoType = "RscDisplayAttributeModuleNuke";

        // Module arguments
        class Arguments {
            class SignalLoss {
                displayName = "Signal Loss";
                description = "Set to false to disable signal and terrain loss values";
                typeName = "BOOL";
                defaultValue = true;
                class values { };
            };
            class FullDuplex {
                displayName = "Full-Duplex Transmissions";
                description = "Set to true to enable full-duplex, or multiple people transmitting";
                typeName = "BOOL";
                defaultValue = false;
                class values { };
            };
            class Interference {
                displayName = "Signal Interference";
                description = "Set to false to disable the interference from multiple transmitters";
                typeName = "BOOL";
                defaultValue = true;
                class values { };
            };
            class IgnoreAntennaDirection {
                displayName = "Ignore Antenna Direction";
                description = "Set to true to disable loss due to antenna directional radiation patterns.";
                typeName = "BOOL";
                defaultValue = false;
                class values { };
            };
        };

        class ModuleDescription: ModuleDescription {
            description = "This module configures different difficulty setting aspects of ACRE.";
            sync[] = {};
        };
    };

    class GVAR(nameChannels): Module_F {
        scope = 2;
        displayName = "Name Channels";
        author = ECSTRING(main,Author);
        category = QGVAR(mission_setup);

        function = "AcreModules_fnc_nameChannels";
        functionPriority = 10;
        isGlobal = 2;
        isTriggerActivated = 0;

        // Menu displayed when the module is placed or double-clicked on by Zeus
        curatorInfoType = "RscDisplayAttributeModuleNuke";

        // Module arguments
        class Arguments {

            class SideSelect {
                displayName = "Side";
                description = "Select the side to name channels for";
                typeName = "NUMBER";
                class values {
                    class All    {name = "All";    value = 1; default = 1;};
                    class West    {name = "West"; value = 2;};
                    class East    {name = "East"; value = 3;};
                    class Ind    {name = "Independent"; value = 4;};
                    class Civ    {name = "Civilian"; value = 5;};
                };
            };

            class Channel_1 {
                displayName = "Channel 1";
                description = "Name of Channel 1";
                defaultValue = "PLTNET 1";
            };
            class Channel_2 {
                displayName = "Channel 2";
                description = "Name of Channel 2";
                defaultValue = "PLTNET 2";
            };
            class Channel_3 {
                displayName = "Channel 3";
                description = "Name of Channel 3";
                defaultValue = "PLTNET 3";
            };
            class Channel_4 {
                displayName = "Channel 4";
                description = "Name of Channel 4";
                defaultValue = "COYNET 1";
            };
            class Channel_5 {
                displayName = "Channel 5";
                description = "Name of Channel 5";
                defaultValue = "CASNET 1";
            };
            class Channel_6 {
                displayName = "Channel 6";
                description = "Name of Channel 6";
                defaultValue = "CASNET 2";
            };
            class Channel_7 {
                displayName = "Channel 7";
                description = "Name of Channel 7";
                defaultValue = "CASNET 3";
            };
            class Channel_8 {
                displayName = "Channel 8";
                description = "Name of Channel 8";
                defaultValue = "FIRES";
            };
            class Channel_9 {
                displayName = "Channel 9";
                description = "Name of Channel 9";
                defaultValue = "LOGISTICS";
            };
            class Channel_10 {
                displayName = "Channel 10";
                description = "Name of Channel 10";
                defaultValue = "SUPPORT";
            };
        };

        class ModuleDescription: ModuleDescription {
            description = "This module defines basic channel naming for a mission in ACRE";
            sync[] = {};
        };
    };
};
