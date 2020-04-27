class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACRE_Interact {
                displayName = CSTRING(radios);
                condition = QUOTE(true);
                exceptions[] = {"isNotInside", "isNotSitting"};
                statement = ""; // With no statement the action will only show if it has children
                insertChildren = QUOTE(_this call FUNC(radioListChildrenActions));
                priority = 0.1;
                icon = ICON_RADIO_CALL;
            };
        };
    };
};
