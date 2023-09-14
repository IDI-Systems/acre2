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
        displayName = CSTRING(basicMissionSetup_Module_DisplayName);
        author = ECSTRING(main,Author);
        category = QGVAR(mission_setup);
        icon = "\a3\Modules_F_Curator\Data\iconRadio_ca.paa";

        function = "AcreModules_fnc_basicMissionSetup";
        functionPriority = 1;
        isGlobal = 2;
        isTriggerActivated = 0;

        // Menu displayed when the module is placed or double-clicked on by Zeus
        curatorInfoType = "RscDisplayAttributeModuleNuke";

        // Module arguments
        class Arguments {
            class RadioSetup {
                displayName = CSTRING(basicMissionSetup_RadioSetup_DisplayName);
                description = CSTRING(basicMissionSetup_RadioSetup_Description);
                typeName = "BOOL";
                class values { };
            };
            class BabelSetup {
                displayName = CSTRING(basicMissionSetup_BabelSetup_DisplayName);
                description = CSTRING(basicMissionSetup_BabelSetup_Description);
                typeName = "NUMBER";
                class values {
                    class AllDifferent {
                        name = CSTRING(basicMissionSetup_BabelSetup_AllDifferent);
                        value = 1;
                    };
                    class SharingDifferent {
                        name = CSTRING(basicMissionSetup_BabelSetup_SharingDifferent);
                        value = 2;
                        default = 2;
                    };
                    class No {
                        name = CSTRING(basicMissionSetup_BabelSetup_No);
                        value = 0;
                    };
                };
            };
            class DefaultRadio {
                displayName = CSTRING(basicMissionSetup_DefaultRadio_DisplayName);
                description = CSTRING(basicMissionSetup_DefaultRadio_Description);
                defaultValue = "ACRE_PRC343";
            };
            class DefaultRadio_Two {
                displayName = CSTRING(basicMissionSetup_DefaultRadio_Two_DisplayName);
                description = CSTRING(basicMissionSetup_DefaultRadio_Description);
                defaultValue = "";
            };
            class DefaultRadio_Three {
                displayName = CSTRING(basicMissionSetup_DefaultRadio_Three_DisplayName);
                description = CSTRING(basicMissionSetup_DefaultRadio_Description);
                defaultValue = "";
            };
            class DefaultRadio_Four {
                displayName = CSTRING(basicMissionSetup_DefaultRadio_Four_DisplayName);
                description = CSTRING(basicMissionSetup_DefaultRadio_Description);
                defaultValue = "";
            };
        };

        class ModuleDescription: ModuleDescription {
            description = CSTRING(basicMissionSetup_Module_Description);
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
                defaultValue = 1;
                class values { };
            };
            class FullDuplex {
                displayName = "Full-Duplex Transmissions";
                description = "Set to true to enable full-duplex, or multiple people transmitting";
                typeName = "BOOL";
                defaultValue = 0;
                class values { };
            };
            class Interference {
                displayName = "Signal Interference";
                description = "Set to false to disable the interference from multiple transmitters";
                typeName = "BOOL";
                defaultValue = 1;
                class values { };
            };
            class IgnoreAntennaDirection {
                displayName = "Ignore Antenna Direction";
                description = "Set to true to disable loss due to antenna directional radiation patterns.";
                typeName = "BOOL";
                defaultValue = 0;
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
        displayName = CSTRING(nameChannels_Module_DisplayName);
        author = ECSTRING(main,Author);
        category = QGVAR(mission_setup);
        icon = "\a3\Modules_F_Curator\Data\iconRadio_ca.paa";

        function = "AcreModules_fnc_nameChannels";
        functionPriority = 10;
        isGlobal = 2;
        isTriggerActivated = 0;

        // Menu displayed when the module is placed or double-clicked on by Zeus
        curatorInfoType = "RscDisplayAttributeModuleNuke";

        // Module arguments
        class Arguments {

            class SideSelect {
                displayName = CSTRING(nameChannels_SideSelect_DisplayName);
                description = CSTRING(nameChannels_SideSelect_Description);
                typeName = "NUMBER";
                class values {
                    class All {
                        name = CSTRING(nameChannels_SideSelect_All);
                        value = 1;
                        default = 1;
                    };
                    class West {
                        name = CSTRING(nameChannels_SideSelect_West);
                        value = 2;
                    };
                    class East {
                        name = CSTRING(nameChannels_SideSelect_East);
                        value = 3;
                    };
                    class Ind {
                        name = CSTRING(nameChannels_SideSelect_Ind);
                        value = 4;
                    };
                    class Civ {
                        name = CSTRING(nameChannels_SideSelect_Civ);
                        value = 5;
                    };
                };
            };

            class Channel_1 {
                displayName = CSTRING(nameChannels_Channel_1_DisplayName);
                description = CSTRING(nameChannels_Channel_1_Description);
                defaultValue = "PLTNET 1";
            };
            class Channel_2 {
                displayName = CSTRING(nameChannels_Channel_2_DisplayName);
                description = CSTRING(nameChannels_Channel_2_Description);
                defaultValue = "PLTNET 2";
            };
            class Channel_3 {
                displayName = CSTRING(nameChannels_Channel_3_DisplayName);
                description = CSTRING(nameChannels_Channel_3_Description);
                defaultValue = "PLTNET 3";
            };
            class Channel_4 {
                displayName = CSTRING(nameChannels_Channel_4_DisplayName);
                description = CSTRING(nameChannels_Channel_4_Description);
                defaultValue = "COYNET 1";
            };
            class Channel_5 {
                displayName = CSTRING(nameChannels_Channel_5_DisplayName);
                description = CSTRING(nameChannels_Channel_5_Description);
                defaultValue = "CASNET 1";
            };
            class Channel_6 {
                displayName = CSTRING(nameChannels_Channel_6_DisplayName);
                description = CSTRING(nameChannels_Channel_6_Description);
                defaultValue = "CASNET 2";
            };
            class Channel_7 {
                displayName = CSTRING(nameChannels_Channel_7_DisplayName);
                description = CSTRING(nameChannels_Channel_7_Description);
                defaultValue = "CASNET 3";
            };
            class Channel_8 {
                displayName = CSTRING(nameChannels_Channel_8_DisplayName);
                description = CSTRING(nameChannels_Channel_8_Description);
                defaultValue = "FIRES";
            };
            class Channel_9 {
                displayName = CSTRING(nameChannels_Channel_9_DisplayName);
                description = CSTRING(nameChannels_Channel_9_Description);
                defaultValue = "LOGISTICS";
            };
            class Channel_10 {
                displayName = CSTRING(nameChannels_Channel_10_DisplayName);
                description = CSTRING(nameChannels_Channel_10_Description);
                defaultValue = "SUPPORT";
            };
        };

        class ModuleDescription: ModuleDescription {
            description = CSTRING(nameChannels_Module_Description);
            sync[] = {};
        };
    };
};
