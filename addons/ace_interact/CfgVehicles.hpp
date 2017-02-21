class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACRE_Interact {
                displayName = CSTRING(radios);
                condition = "true";
                exceptions[] = {"isNotInside", "isNotSitting"};
                statement = "true";
                insertChildren = "_this call acre_ace_interact_fnc_radioListChildrenActions";
                priority = 0.1;
                icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
            };
        };

        class ACE_Actions {
            class ACE_MainActions {
                class ACRE_Interact {
                    displayName = CSTRING(intercom);
                    condition = QUOTE([] call FUNC(checkIntercomInfantry));
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    statement = "true";
                    insertChildren = QUOTE(_this call FUNC(externalIntercomListChildrenActions));
                    priority = 0.1;
                    icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
                 };
             };
         };
    };

    class LandVehicle;
    class Car;
    class Car_F : Car {};
    class Wheeled_APC_F : Car_F {
        class ACE_Actions {
            class ACE_MainActions {
                class ACRE_Interact {
                    displayName = CSTRING(intercom);
                    condition = "true";
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    statement = "true";
                    insertChildren = QUOTE(_this call FUNC(externalIntercomListChildrenActions));
                    priority = 0.1;
                    icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
                 };
             };
         };
    };

    class MRAP_02_base_F: Car_F {
        class ACE_Actions {
            class ACE_MainActions {
                class ACRE_Interact {
                    displayName = CSTRING(externalIntercom);
                    condition = "true";
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    statement = "true";
                    insertChildren = QUOTE(_this call FUNC(externalIntercomListChildrenActions));
                    priority = 0.1;
                    icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
                 };
             };
         };
    };

    class Tank : LandVehicle {
        class ACE_Actions {
            class ACE_MainActions {
                class ACRE_Interact {
                    displayName = CSTRING(intercom);
                    condition = "true";
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    statement = "true";
                    insertChildren = QUOTE(_this call FUNC(externalIntercomListChildrenActions));
                    priority = 0.1;
                    icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
                 };
             };
         };
    };
};
