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
                class ACRE_InfantryPhone {
                    displayName = CSTRING(infantryPhone);
                    condition = QUOTE(_player call FUNC(checkIntercomInfantry));
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    statement = "true";
                    insertChildren = QUOTE(_this call FUNC(infantryPhoneChildrenActions));
                    priority = 0.1;
                    icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
                 };
             };
         };
    };
};
