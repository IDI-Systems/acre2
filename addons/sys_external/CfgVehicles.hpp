class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_Actions {
            class ACE_MainActions {
                class ACRE_Interact {
                    displayName = CSTRING(externalRadios);
                    condition = "true";
                    exceptions[] = {"isNotInside", "isNotSitting"};
                    statement = "true";
                    insertChildren = QUOTE(_this call FUNC(listChildrenActions));
                    priority = 0.1;
                    icon = ICON_RADIO_CALL;
                };
            };
        };
    };
};
