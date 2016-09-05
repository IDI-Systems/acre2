class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACRE_Interact {
                displayName = "Radios";
                condition = "true";
                exceptions[] = {"isNotInside"};
				statement = "true";
                insertChildren = "_this call acre_ace_interact_fnc_radioListChildrenActions";
                priority = 0.1;
                icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
            };
        };
    };
};